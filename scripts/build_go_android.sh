#!/usr/bin/env bash
# ==============================================================================
# build_go_android.sh
# Cross-compiles Go Rclone core backend for Android architectures (ARM & x86)
# using Android NDK Clang toolchain or gomobile.
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
GO_BACKEND_DIR="$PROJECT_ROOT/go_backend"
OUTPUT_BASE_DIR="$PROJECT_ROOT/android/app/src/main/jniLibs"
MIN_API=21

# Supported ABIs: arm64-v8a, armeabi-v7a, x86_64, x86
DEFAULT_ABIS=("arm64-v8a" "armeabi-v7a" "x86_64")

find_ndk() {
    if [ -n "$ANDROID_NDK_HOME" ] && [ -d "$ANDROID_NDK_HOME" ]; then
        echo "$ANDROID_NDK_HOME"
        return 0
    fi
    if [ -n "$ANDROID_NDK_ROOT" ] && [ -d "$ANDROID_NDK_ROOT" ]; then
        echo "$ANDROID_NDK_ROOT"
        return 0
    fi

    local local_props="$PROJECT_ROOT/android/local.properties"
    if [ -f "$local_props" ]; then
        local ndk_from_props
        ndk_from_props=$(grep "^ndk.dir=" "$local_props" 2>/dev/null | cut -d'=' -f2- | tr -d '\r')
        if [ -n "$ndk_from_props" ] && [ -d "$ndk_from_props" ]; then
            echo "$ndk_from_props"
            return 0
        fi
        local sdk_from_props
        sdk_from_props=$(grep "^sdk.dir=" "$local_props" 2>/dev/null | cut -d'=' -f2- | tr -d '\r')
        if [ -n "$sdk_from_props" ] && [ -d "$sdk_from_props/ndk" ]; then
            local latest_ndk
            latest_ndk=$(ls -d "$sdk_from_props/ndk/"* 2>/dev/null | sort -V | tail -n 1)
            if [ -n "$latest_ndk" ] && [ -d "$latest_ndk" ]; then
                echo "$latest_ndk"
                return 0
            fi
        fi
    fi

    if [ -n "$ANDROID_HOME" ] && [ -d "$ANDROID_HOME/ndk" ]; then
        # Pick the latest NDK version directory
        local latest_ndk
        latest_ndk=$(ls -d "$ANDROID_HOME/ndk/"* 2>/dev/null | sort -V | tail -n 1)
        if [ -n "$latest_ndk" ] && [ -d "$latest_ndk" ]; then
            echo "$latest_ndk"
            return 0
        fi
    fi
    for standard_path in "$HOME/Android/Sdk/ndk/"* "/var/home/yoga/FlutterDev/android-sdk/ndk/"* "/usr/local/share/android-sdk/ndk/"* "/opt/android-sdk/ndk/"*; do
        if [ -d "$standard_path" ]; then
            echo "$standard_path"
            return 0
        fi
    done
    return 1
}

detect_host_tag() {
    local os
    os="$(uname -s | tr '[:upper:]' '[:lower:]')"
    case "$os" in
        linux*)  echo "linux-x86_64" ;;
        darwin*)
            if [ "$(uname -m)" = "arm64" ]; then
                echo "darwin-x86_64" # Clang toolchains in NDK are often fat/darwin-x86_64
            else
                echo "darwin-x86_64"
            fi
            ;;
        msys*|cygwin*|mingw*) echo "windows-x86_64" ;;
        *) echo "linux-x86_64" ;;
    esac
}

check_env() {
    echo "=== Checking Android Go compilation environment ==="
    if command -v go >/dev/null 2>&1; then
        echo "✓ Go compiler: $(go version)"
    else
        echo "✗ Go compiler not found on PATH"
        return 1
    fi

    local ndk_path
    if ndk_path=$(find_ndk); then
        echo "✓ Android NDK found at: $ndk_path"
        local host_tag
        host_tag="$(detect_host_tag)"
        local llvm_bin="$ndk_path/toolchains/llvm/prebuilt/$host_tag/bin"
        if [ -d "$llvm_bin" ]; then
            echo "✓ NDK LLVM Clang toolchain found: $llvm_bin"
        else
            echo "⚠ NDK directory found but toolchain host tag '$host_tag' not found in $llvm_bin"
        fi
    else
        echo "⚠ Android NDK not found. To build for Android, set ANDROID_NDK_HOME or install via Android Studio."
        if command -v gomobile >/dev/null 2>&1; then
            echo "✓ Gomobile detected as fallback"
        fi
    fi
    return 0
}

build_abi() {
    local abi="$1"
    local ndk_path="$2"
    local host_tag
    host_tag="$(detect_host_tag)"
    local llvm_bin="$ndk_path/toolchains/llvm/prebuilt/$host_tag/bin"

    local goarch=""
    local goarm=""
    local cc_prefix=""

    case "$abi" in
        "arm64-v8a")
            goarch="arm64"
            cc_prefix="aarch64-linux-android"
            ;;
        "armeabi-v7a")
            goarch="arm"
            goarm="7"
            cc_prefix="armv7a-linux-androideabi"
            ;;
        "x86_64")
            goarch="amd64"
            cc_prefix="x86_64-linux-android"
            ;;
        "x86")
            goarch="386"
            cc_prefix="i686-linux-android"
            ;;
        *)
            echo "Error: Unknown ABI: $abi"
            exit 1
            ;;
    esac

    local cc_compiler="$llvm_bin/${cc_prefix}${MIN_API}-clang"
    if [ ! -f "$cc_compiler" ]; then
        # Try finding any clang matching prefix in llvm_bin
        local alt_cc
        alt_cc=$(find "$llvm_bin" -name "${cc_prefix}*-clang" 2>/dev/null | sort -V | head -n 1)
        if [ -n "$alt_cc" ] && [ -f "$alt_cc" ]; then
            cc_compiler="$alt_cc"
        else
            echo "Error: Clang compiler for $abi not found in $llvm_bin (expected ${cc_prefix}${MIN_API}-clang)"
            exit 1
        fi
    fi

    local target_dir="$OUTPUT_BASE_DIR/$abi"
    mkdir -p "$target_dir"
    local output_file="$target_dir/librclone_wrapper.so"

    echo "--> Compiling Go backend for $abi (GOARCH=$goarch, CC=$(basename "$cc_compiler"))..."

    (
        cd "$GO_BACKEND_DIR"
        export CGO_ENABLED=1
        export GOOS=android
        export GOARCH="$goarch"
        [ -n "$goarm" ] && export GOARM="$goarm"
        export CC="$cc_compiler"

        go build -ldflags="-s -w" -buildmode=c-shared -o "$output_file" main.go
    )

    if [ -x "$llvm_bin/llvm-strip" ]; then
        "$llvm_bin/llvm-strip" --strip-unneeded "$output_file"
    fi

    echo "✓ Built $output_file ($(du -h "$output_file" | cut -f1))"
}

# --- CLI Options Handling ---
TARGET_ABIS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --check-env)
            check_env
            exit 0
            ;;
        --abi)
            TARGET_ABIS+=("$2")
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [--check-env] [--abi <arm64-v8a|armeabi-v7a|x86_64|x86>]"
            exit 0
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done

if [ ${#TARGET_ABIS[@]} -eq 0 ]; then
    TARGET_ABIS=("${DEFAULT_ABIS[@]}")
fi

echo "=== Building Go Backend for Android ==="

NDK_DIR=$(find_ndk || true)

if [ -z "$NDK_DIR" ] || [ ! -d "$NDK_DIR" ]; then
    echo "⚠ Android NDK was not detected."
    echo "Checked: ANDROID_NDK_HOME, ANDROID_NDK_ROOT, and standard SDK paths."
    echo "If precompiled .so files exist in $OUTPUT_BASE_DIR, they will be used."
    exit 0
fi

for abi in "${TARGET_ABIS[@]}"; do
    build_abi "$abi" "$NDK_DIR"
done

echo "=== Android Go compilation completed successfully! ==="

