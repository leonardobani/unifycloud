# Installation & Build Guide 📦

This guide covers everything you need to know about installing **UnifyCloud** on your devices as an end user, as well as building it from source as a developer.

---

## 💻 Supported Platforms & System Requirements

UnifyCloud runs natively across desktop and mobile platforms:

| Platform | Minimum OS Version | Architectures | Distribution Formats |
|---|---|---|---|
| **Android** | Android 7.0 (API 24+) | `arm64-v8a`, `armeabi-v7a`, `x86_64` | F-Droid, Standalone APK |
| **Linux** | Modern Distro (glibc 2.31+) | `x86_64` | Flatpak, Standalone Tarball |
| **Windows** | Windows 10 (64-bit) / Windows 11 | `x86_64` | Portable Zip, Installer |
| **macOS** | macOS 11 (Big Sur) or newer | Apple Silicon (`arm64`), Intel (`x86_64`) | `.dmg`, `.app` bundle |
| **iOS** | iOS 13.0 or newer | `arm64` | TestFlight, AltStore / Sideloadly |

---

## 1. 📱 Android (Mobile & Tablet)

### Option A: Install from F-Droid (Recommended for FOSS Users)
UnifyCloud is packaged for F-Droid with 100% reproducible builds and zero proprietary tracking libraries.
1. Install the [F-Droid Client](https://f-droid.org/) if not already installed.
2. Search for **UnifyCloud** (Package ID: `io.gitlab.leorise25.unifycloud`).
3. Tap **Install** and accept updates automatically through F-Droid.

### Option B: Download Direct APK Releases
If you do not use F-Droid, download pre-compiled APKs directly from the [GitLab Releases](https://gitlab.com/leorise25/unifycloud/-/releases) page.

We provide both architecture-specific APKs (~45 MB) and a universal APK (~95 MB):

| APK File | Target Device |
|---|---|
| `app-arm64-v8a-release.apk` | **Recommended.** Modern smartphones & tablets (built within the last 7 years). |
| `app-armeabi-v7a-release.apk` | Legacy 32-bit Android smartphones. |
| `app-x86_64-release.apk` | Android emulators, ChromeOS Chromebooks, Intel-based tablets. |
| `app-release.apk` | Universal fat APK containing all architectures combined. |

#### Installing via ADB (Command Line)
```bash
adb install -r app-arm64-v8a-release.apk
```

#### Installing via File Manager on Device
1. Open the downloaded `.apk` file using your Android File Manager.
2. If prompted, grant permission to *"Install unknown apps"* for your browser or file manager.
3. Tap **Install** and then **Open**.

### ⚠️ Critical Android Permissions & Setup

To ensure uninterrupted cloud synchronization and local file access:

1. **All Files Access (`MANAGE_EXTERNAL_STORAGE`)**:
   - On Android 11 and above, UnifyCloud will prompt you to enable *"Allow access to manage all files"*.
   - This permission is required to allow UnifyCloud to browse local directories (Photos, Documents, Downloads) and execute bidirectional folder synchronization.
2. **Battery Optimization Exemption (Unrestricted Battery)**:
   - By default, Android aggressive battery managers (Doze mode, OEM task killers) will freeze or kill background apps after 1–3 minutes when the screen turns off.
   - Go to: **Settings** ➔ **Apps** ➔ **UnifyCloud** ➔ **Battery** ➔ Select **Unrestricted** (or "Don't Optimize").
   - This ensures background uploads, downloads, and scheduled sync rules finish without interruption.
3. **Notification Permission**:
   - Required on Android 13+ to display the ongoing Foreground Service notification indicating active transfer speeds (`MB/s`) and percentage.

---

## 2. 🐧 Linux Desktop

UnifyCloud supports all major Linux distributions (Fedora, Ubuntu, Debian, Arch Linux, openSUSE, Pop!_OS, Bazzite, SteamOS).

### Option A: Flatpak (Recommended)
Flatpak provides a sandboxed, dependency-free container that works across every distribution.

#### Installing a Downloaded `.flatpak` Bundle:
```bash
flatpak install unifycloud.flatpak
```

#### Running the Flatpak Application:
UnifyCloud will appear in your desktop application launcher (GNOME Dash, KDE Kickoff, etc.). You can also run it via terminal:
```bash
flatpak run com.example.unifycloud
```

#### Flatpak Security & Portal Permissions:
The Flatpak manifest (`packaging/flatpak/com.example.unifycloud.yml`) includes configured sandbox permissions:
- `--share=network`: Connects to cloud provider APIs.
- `--filesystem=host`: Grants access to your local filesystem for browsing and folder sync.
- `--talk-name=org.freedesktop.secrets`: Connects to your system Keyring (GNOME Keyring / KWallet) to store OAuth tokens encrypted in RAM.
- `--socket=wayland` and `--socket=fallback-x11`: Native graphics acceleration on both Wayland and X11 display servers.

---

### Option B: Standalone Release Bundle (Native Binary)

If you prefer running UnifyCloud natively without Flatpak:

1. Download the `unifycloud-linux-x64.tar.gz` archive from [GitLab Releases](https://gitlab.com/leorise25/unifycloud/-/releases).
2. Extract the archive:
   ```bash
   tar -xzf unifycloud-linux-x64.tar.gz
   cd unifycloud-linux-x64/
   ```
3. Ensure runtime dependencies are installed:
   - **Debian / Ubuntu / Linux Mint**:
     ```bash
     sudo apt update && sudo apt install -y libgtk-3-0 libsecret-1-0 libjson-glib-1.0-0
     ```
   - **Fedora / RHEL / CentOS**:
     ```bash
     sudo dnf install -y gtk3 libsecret json-glib
     ```
   - **Arch Linux / Manjaro**:
     ```bash
     sudo pacman -S gtk3 libsecret json-glib
     ```
4. Run the executable:
   ```bash
   ./unifycloud
   ```

---

## 3. 🪟 Windows Desktop

### Installation Steps:
1. Download `unifycloud-windows-x64.zip` from [GitLab Releases](https://gitlab.com/leorise25/unifycloud/-/releases).
2. Right-click the `.zip` file and select **Extract All...** to a permanent location (e.g., `C:\Program Files\UnifyCloud` or `C:\Users\<YourUser>\AppData\Local\Programs\UnifyCloud`).
3. Double-click `unifycloud.exe` to launch the application.
4. *(Optional)* Right-click `unifycloud.exe` ➔ **Pin to Start** or **Pin to taskbar**.

### Prerequisites:
- **Visual C++ Redistributable**: Ensure the **Microsoft Visual C++ 2015–2022 Redistributable (x64)** is installed. Most Windows installations already have this. If missing, download it directly from [Microsoft Support](https://aka.ms/vs/17/release/vc_redist.x64.exe).

### Windows Defender SmartScreen Note:
If Windows SmartScreen displays *"Windows protected your PC"* on the first run (because the open-source binary is freshly released and not code-signed with an expensive EV certificate):
1. Click **More info**.
2. Click **Run anyway**.

---

## 4. 🍎 macOS & iOS

### macOS Desktop:
1. Download `UnifyCloud-macOS.dmg` from [GitLab Releases](https://gitlab.com/leorise25/unifycloud/-/releases).
2. Open the `.dmg` file and drag **UnifyCloud.app** into your **Applications** folder.
3. Launch UnifyCloud from Launchpad or Spotlight.

> [!NOTE]
> If macOS Gatekeeper displays *"UnifyCloud cannot be opened because developer cannot be verified"*:
> 1. Open **System Settings** ➔ **Privacy & Security**.
> 2. Scroll down to the **Security** section.
> 3. Click **Open Anyway** next to UnifyCloud.

---

### iOS (iPhone & iPad):
Due to Apple App Store restrictions on third-party cloud engines and compilation models, iOS binaries can be installed via:
1. **Apple TestFlight**: Join our public testing channel via GitLab Releases.
2. **Sideloading (AltStore / Sideloadly / TrollStore)**:
   - Download the `.ipa` file from GitLab Releases.
   - Sideload using your personal Apple ID.

---

## 5. 🛠️ Building from Source (Developer Guide)

If you want to contribute, modify code, or compile UnifyCloud from scratch, follow these instructions.

### Prerequisites

| Tool | Minimum Version | Notes |
|---|---|---|
| **Flutter SDK** | `3.13.3+` | Run `flutter doctor` to verify setup |
| **Go Compiler** | `1.22+` | Required to compile the CGO Rclone core |
| **C/C++ Compiler** | GCC 11+ or Clang 14+ | Host CGO toolchain |
| **CMake & Ninja** | Latest | Required for Linux/Windows native desktop embedding |
| **Android NDK** | `r26` to `r28` | Required for cross-compiling Go backend for Android ABIs |
| **Xcode** | `15+` | Required for macOS and iOS compilation |

---

### Step 1: Clone the Repository
```bash
git clone https://gitlab.com/leorise25/unifycloud.git
cd unifycloud
```

---

### Step 2: Cross-Compile the Native Go Backend (`librclone_wrapper`)

The embedded Go backend must be compiled into native dynamic libraries (`.so`, `.dll`, `.dylib`) or static archives before launching Flutter.

#### A. For Linux Desktop:
```bash
cd go_backend
go build -buildmode=c-shared -o librclone_wrapper.so main.go
cd ..
```

#### B. For Android (All ABIs: `arm64-v8a`, `armeabi-v7a`, `x86_64`):
Ensure Android NDK is installed and run the automated compilation script:
```bash
# On Linux / macOS:
bash scripts/build_go_android.sh

# On Windows:
scripts\build_go_android.bat
```
This automatically compiles `librclone_wrapper.so` for each ABI and outputs them to `android/app/src/main/jniLibs/<abi>/`.

#### C. For Windows Desktop:
Using MinGW-w64 GCC or MSVC:
```cmd
cd go_backend
go build -buildmode=c-shared -o librclone_wrapper.dll main.go
cd ..
```

#### D. For macOS Desktop:
```bash
cd go_backend
go build -buildmode=c-shared -o librclone_wrapper.dylib main.go
cd ..
```

#### E. For iOS (Device & Simulator):
```bash
bash scripts/build_go_ios.sh
```

---

### Step 3: Fetch Flutter Dependencies & Verify
```bash
flutter pub get
dart analyze
flutter test
```

---

### Step 4: Run or Build Release

#### Run in Debug Mode:
```bash
# Linux:
flutter run -d linux

# Android:
flutter run -d android

# Windows:
flutter run -d windows

# macOS:
flutter run -d macos
```

#### Build Production Releases:
```bash
# Android Release APK (split per ABI for smaller size):
flutter build apk --release --split-per-abi

# Linux Release Bundle:
flutter build linux --release

# Windows Release Bundle:
flutter build windows --release

# macOS Release App:
flutter build macos --release
```

The resulting executables and packages will be located under the `build/` directory!
