@echo off
rem ==============================================================================
rem build_go_android.bat
rem Cross-compiles Go Rclone core backend for Android architectures on Windows
rem ==============================================================================

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."
set "GO_BACKEND_DIR=%PROJECT_ROOT%\go_backend"
set "OUTPUT_BASE_DIR=%PROJECT_ROOT%\android\app\src\main\jniLibs"
set "MIN_API=21"

if "%1"=="--check-env" goto check_env

rem Look for NDK in ANDROID_NDK_HOME or ANDROID_HOME\ndk
set "NDK_DIR="
if defined ANDROID_NDK_HOME (
    if exist "%ANDROID_NDK_HOME%" set "NDK_DIR=%ANDROID_NDK_HOME%"
)
if not defined NDK_DIR if defined ANDROID_HOME (
    if exist "%ANDROID_HOME%\ndk" (
        for /d %%D in ("%ANDROID_HOME%\ndk\*") do set "NDK_DIR=%%D"
    )
)

if not defined NDK_DIR (
    echo [WARNING] Android NDK was not detected in ANDROID_NDK_HOME or ANDROID_HOME\ndk.
    echo If precompiled .so files exist in %OUTPUT_BASE_DIR%, they will be used.
    exit /b 0
)

echo === Building Go Backend for Android (NDK: %NDK_DIR%) ===

set "HOST_TAG=windows-x86_64"
set "LLVM_BIN=%NDK_DIR%\toolchains\llvm\prebuilt\%HOST_TAG%\bin"

rem arm64-v8a
if not exist "%OUTPUT_BASE_DIR%\arm64-v8a" mkdir "%OUTPUT_BASE_DIR%\arm64-v8a"
pushd "%GO_BACKEND_DIR%"
set "CGO_ENABLED=1"
set "GOOS=android"
set "GOARCH=arm64"
set "CC=%LLVM_BIN%\aarch64-linux-android%MIN_API%-clang.cmd"
if not exist "!CC!" set "CC=%LLVM_BIN%\aarch64-linux-android%MIN_API%-clang"
go build -ldflags="-s -w" -buildmode=c-shared -o "%OUTPUT_BASE_DIR%\arm64-v8a\librclone_wrapper.so" main.go
popd
if exist "%LLVM_BIN%\llvm-strip.exe" "%LLVM_BIN%\llvm-strip.exe" --strip-unneeded "%OUTPUT_BASE_DIR%\arm64-v8a\librclone_wrapper.so"

rem armeabi-v7a
if not exist "%OUTPUT_BASE_DIR%\armeabi-v7a" mkdir "%OUTPUT_BASE_DIR%\armeabi-v7a"
pushd "%GO_BACKEND_DIR%"
set "CGO_ENABLED=1"
set "GOOS=android"
set "GOARCH=arm"
set "GOARM=7"
set "CC=%LLVM_BIN%\armv7a-linux-androideabi%MIN_API%-clang.cmd"
if not exist "!CC!" set "CC=%LLVM_BIN%\armv7a-linux-androideabi%MIN_API%-clang"
go build -ldflags="-s -w" -buildmode=c-shared -o "%OUTPUT_BASE_DIR%\armeabi-v7a\librclone_wrapper.so" main.go
popd
if exist "%LLVM_BIN%\llvm-strip.exe" "%LLVM_BIN%\llvm-strip.exe" --strip-unneeded "%OUTPUT_BASE_DIR%\armeabi-v7a\librclone_wrapper.so"

rem x86_64
if not exist "%OUTPUT_BASE_DIR%\x86_64" mkdir "%OUTPUT_BASE_DIR%\x86_64"
pushd "%GO_BACKEND_DIR%"
set "CGO_ENABLED=1"
set "GOOS=android"
set "GOARCH=amd64"
set "CC=%LLVM_BIN%\x86_64-linux-android%MIN_API%-clang.cmd"
if not exist "!CC!" set "CC=%LLVM_BIN%\x86_64-linux-android%MIN_API%-clang"
go build -ldflags="-s -w" -buildmode=c-shared -o "%OUTPUT_BASE_DIR%\x86_64\librclone_wrapper.so" main.go
popd
if exist "%LLVM_BIN%\llvm-strip.exe" "%LLVM_BIN%\llvm-strip.exe" --strip-unneeded "%OUTPUT_BASE_DIR%\x86_64\librclone_wrapper.so"

echo === Android Go compilation finished ===
exit /b 0

:check_env
echo === Checking Android Go compilation environment ===
where go >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [OK] Go is installed.
) else (
    echo [ERROR] Go compiler not found on PATH.
)
if defined ANDROID_NDK_HOME (
    echo [OK] ANDROID_NDK_HOME is set: %ANDROID_NDK_HOME%
) else (
    echo [WARNING] ANDROID_NDK_HOME is not set.
)
exit /b 0

