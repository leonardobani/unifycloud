# Troubleshooting & Frequently Asked Questions (FAQ) ❓

This document covers solutions to common questions, platform-specific edge cases, and connection errors encountered when using **UnifyCloud**.

---

## 🔑 OAuth & Cloud Connection Issues

### 1. "Port 53682 is already in use by another process"
- **Cause**: UnifyCloud spins up an ephemeral local loopback HTTP server on port `53682` to receive OAuth authorization codes from your browser. If a standalone Rclone CLI process, another cloud client, or a previous instance is occupying that port, the server cannot bind.
- **Solution**:
  - Close any running Rclone CLI instances or previous terminal sessions.
  - On **Linux / macOS**: Open terminal and find the process occupying the port:
    ```bash
    lsof -i :53682
    kill -9 <PID>
    ```
  - On **Windows**:
    ```cmd
    netstat -ano | findstr :53682
    taskkill /PID <PID> /F
    ```
  - If you are using a **Personal Client ID**, UnifyCloud will automatically fall back to an arbitrary free port if `53682` is busy.

---

### 2. Google: "Google hasn't verified this app"
- **Cause**: When using your own personal Client ID in Google Cloud Console, Google flags the project as "Testing" until an expensive verification process is conducted.
- **Solution**:
  - This is completely expected for personal projects.
  - On the warning page, click **Advanced** (bottom left).
  - Click **Go to UnifyCloud Personal (unsafe)**.
  - Check the box to grant Google Drive file permissions and click **Continue**.

---

### 3. Google: "Access blocked: This app's request is invalid" (Error 400)
- **Cause**:
  1. Your Gmail account was not added to the **Test Users** list in Google Cloud Console.
  2. The Google Drive API was not enabled for the project.
- **Solution**:
  - In Google Cloud Console, navigate to **APIs & Services** ➔ **OAuth consent screen**.
  - Scroll down to **Test users**, click **+ Add Users**, and add your exact email address.
  - Verify that **Google Drive API** is toggled to **Enabled** under **APIs & Services** ➔ **Library**.

---

### 4. Microsoft OneDrive: "AADSTS50011: The reply URL specified does not match"
- **Cause**: In your Azure Portal app registration, the Redirect URI does not match UnifyCloud's local loopback callback.
- **Solution**:
  - Go to [Azure Portal](https://portal.azure.com/) ➔ **App registrations** ➔ Your App ➔ **Authentication**.
  - Ensure the redirect URI is added exactly as:
    ```
    http://localhost:53682/
    ```
  - Make sure the platform is configured as **Web** or **Mobile and desktop applications**.

---

### 5. Cloud Provider HTTP Error 429 ("Too Many Requests")
- **Cause**: The cloud provider is throttling API requests because too many requests were made within a short window (especially prevalent when using shared public client IDs).
- **Solution**:
  - Create and configure your own **Personal Client ID & Secret** following our [OAuth Setup Guide](OAuth-Setup-Guide). This gives your account 100% dedicated API quota.
  - In UnifyCloud **Settings**, lower the **Max Concurrent Transfers** slider (e.g. from 4 to 2) to reduce API call density.

---

## 📱 Android-Specific Issues

### 1. Background transfers or sync pause when phone is locked
- **Cause**: Android aggressive battery management (OEM Doze Mode) suspends background network sockets when the screen turns off.
- **Solution**:
  1. Open your phone's **Settings** ➔ **Apps** ➔ **UnifyCloud**.
  2. Tap **Battery** (or *App battery usage*).
  3. Change the setting from *Optimized* to **Unrestricted** (or *"Don't optimize"*).
  4. Ensure UnifyCloud has permission to show notifications (required for the foreground service).

---

### 2. Cannot see or select local folders on Android
- **Cause**: Android 11+ enforces Scoped Storage and requires explicit user consent for full filesystem access.
- **Solution**:
  - Go to: **Settings** ➔ **Apps** ➔ **Special app access** ➔ **All files access** ➔ Enable for **UnifyCloud**.

---

## 🐧 Linux & Flatpak Issues

### 1. "Secret Service / Keyring connection failed"
- **Cause**: UnifyCloud requires a functioning D-Bus Secret Service provider (`gnome-keyring`, `ksecretsservice`, or `keepassxc`) to encrypt tokens. On minimal window managers (i3, Sway, Hyprland) without a desktop environment, the keyring daemon may not be unlocked.
- **Solution**:
  - Ensure `gnome-keyring` or `kwallet` is installed and auto-unlocked at login:
    ```bash
    sudo apt install -y gnome-keyring libsecret-1-0 # Debian/Ubuntu
    sudo dnf install -y gnome-keyring libsecret     # Fedora
    sudo pacman -S gnome-keyring libsecret         # Arch
    ```

---

### 2. Flatpak cannot access external USB drives or secondary hard drives
- **Cause**: Flatpak sandbox defaults to user home and standard host locations.
- **Solution**:
  - Grant filesystem access to external mount points via terminal:
    ```bash
    flatpak override --user --filesystem=/run/media com.example.unifycloud
    flatpak override --user --filesystem=/media com.example.unifycloud
    ```
  - Or use the graphical [Flatseal](https://flathub.org/apps/com.github.tchx84.Flatseal) utility to toggle filesystem permissions.

---

## 🪟 Windows Desktop Issues

### 1. "VCRUNTIME140.dll is missing" or "MSVCP140.dll is missing"
- **Cause**: The Microsoft Visual C++ runtime libraries are not installed on your system.
- **Solution**:
  - Download and install the official [Microsoft Visual C++ 2015-2022 Redistributable (x64)](https://aka.ms/vs/17/release/vc_redist.x64.exe).

---

## 💬 Frequently Asked Questions (FAQ)

### Is UnifyCloud free and open-source?
**Yes.** UnifyCloud is licensed under the **GNU General Public License v3.0 (GPL-3.0)**. It is free to use, modify, and distribute.

### Does UnifyCloud collect any telemetry or track my files?
**No. Zero tracking, zero telemetry, zero analytics.** All network connections are direct peer-to-cloud connections between your device and your cloud provider. No middleman servers or proxy relays ever inspect or touch your data.

### Does UnifyCloud write my passwords or cloud tokens to disk?
**Never in plaintext.** UnifyCloud uses a zero-plaintext in-RAM architecture. Tokens are stored encrypted in your operating system's hardware-backed Keystore or Keychain and decrypted directly into memory for the Go CGO engine.

### Can I transfer files directly between two different cloud providers?
**Yes.** UnifyCloud streams data directly between cloud remotes in memory chunks without downloading files to your physical disk first.

### Can I access my Crypt Vault files using standard tools?
**Yes.** UnifyCloud's Crypt implementation is 100% compliant with standard Rclone Crypt. You can open, mount, or decrypt your files on any machine using the official Rclone command-line tool with your password and salt.

### How do I report a bug or request a new feature?
Please open an issue on our [GitLab Issue Tracker](https://gitlab.com/leorise25/unifycloud/-/issues). Include your operating system, UnifyCloud version, and any relevant log details.
