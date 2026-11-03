#!/usr/bin/env bash
# ==============================================================================
# build_go_ios.sh
# Compiles Go Rclone core backend into an iOS static C archive (.a) and header (.h)
# for both physical iOS devices (arm64) and iOS Simulator (arm64 / x86_64).
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
GO_BACKEND_DIR="$PROJECT_ROOT/go_backend"
OUTPUT_DIR="$PROJECT_ROOT/ios/Libraries"
MIN_IOS_VERSION="13.0"

check_env() {
    echo "=== Checking iOS Go compilation environment ==="
    if command -v go >/dev/null 2>&1; then
        echo "✓ Go compiler: $(go version)"
    else
        echo "✗ Go compiler not found on PATH"
        return 1
    fi

    if command -v xcrun >/dev/null 2>&1; then
        echo "✓ Xcode command line tools found"
        local sdk_path
        sdk_path=$(xcrun --sdk iphoneos --show-sdk-path 2>/dev/null || true)
        if [ -n "$sdk_path" ]; then
            echo "✓ iOS Device SDK found at: $sdk_path"
        else
            echo "⚠ iOS Device SDK (iphoneos) not found"
        fi
        local sim_path
        sim_path=$(xcrun --sdk iphonesimulator --show-sdk-path 2>/dev/null || true)
        if [ -n "$sim_path" ]; then
            echo "✓ iOS Simulator SDK found at: $sim_path"
        else
            echo "⚠ iOS Simulator SDK (iphonesimulator) not found"
        fi
    else
        echo "⚠ xcrun not found (macOS / Xcode required to compile for iOS)"
    fi
    return 0
}

build_ios_target() {
    local target_sdk="$1"
    local goarch="$2"
    local output_file="$3"

    local clang_path
    clang_path=$(xcrun --sdk "$target_sdk" --find clang)
    local sdk_path
    sdk_path=$(xcrun --sdk "$target_sdk" --show-sdk-path)

    echo "--> Compiling for SDK: $target_sdk ($goarch)..."

    local target_flag=""
    if [ "$target_sdk" = "iphoneos" ]; then
        target_flag="-target arm64-apple-ios${MIN_IOS_VERSION} -isysroot ${sdk_path}"
    else
        target_flag="-target ${goarch}-apple-ios${MIN_IOS_VERSION}-simulator -isysroot ${sdk_path}"
    fi

    (
        cd "$GO_BACKEND_DIR"
        export CGO_ENABLED=1
        export GOOS=ios
        export GOARCH="$goarch"
        export CC="$clang_path"
        export CGO_CFLAGS="$target_flag"
        export CGO_LDFLAGS="$target_flag"

        go build -ldflags="-s -w" -buildmode=c-archive -o "$output_file" main.go
    )
}

# --- CLI Options Handling ---
BUILD_SIMULATOR=false
BUILD_DEVICE=true

while [[ $# -gt 0 ]]; do
    case "$1" in
        --check-env)
            check_env
            exit 0
            ;;
        --simulator)
            BUILD_SIMULATOR=true
            BUILD_DEVICE=false
            shift
            ;;
        --all)
            BUILD_SIMULATOR=true
            BUILD_DEVICE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--check-env] [--simulator] [--all]"
            exit 0
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done

if ! command -v xcrun >/dev/null 2>&1; then
    echo "⚠ macOS and Xcode tools (xcrun) are required to cross-compile Go for iOS."
    echo "If running on Linux, this script can only check environment or be run in a macOS CI runner."
    mkdir -p "$OUTPUT_DIR"
    if [ -f "$GO_BACKEND_DIR/librclone_wrapper.h" ]; then
        cp "$GO_BACKEND_DIR/librclone_wrapper.h" "$OUTPUT_DIR/librclone_wrapper.h"
        echo "✓ Synchronized librclone_wrapper.h into $OUTPUT_DIR"
    fi
    exit 0
fi

mkdir -p "$OUTPUT_DIR"

if [ "$BUILD_DEVICE" = true ]; then
    build_ios_target "iphoneos" "arm64" "$OUTPUT_DIR/librclone_wrapper.a"
    echo "✓ Built iOS Device library: $OUTPUT_DIR/librclone_wrapper.a"
fi

if [ "$BUILD_SIMULATOR" = true ]; then
    # Detect host architecture for simulator (arm64 for Apple Silicon, amd64 for Intel)
    SIM_ARCH="arm64"
    if [ "$(uname -m)" = "x86_64" ]; then
        SIM_ARCH="amd64"
    fi
    build_ios_target "iphonesimulator" "$SIM_ARCH" "$OUTPUT_DIR/librclone_wrapper_sim.a"
    echo "✓ Built iOS Simulator library: $OUTPUT_DIR/librclone_wrapper_sim.a"
fi

# Ensure header is accessible in Libraries/
if [ -f "$GO_BACKEND_DIR/librclone_wrapper.h" ]; then
    cp "$GO_BACKEND_DIR/librclone_wrapper.h" "$OUTPUT_DIR/librclone_wrapper.h"
fi

echo "=== iOS Go compilation finished successfully! ==="

