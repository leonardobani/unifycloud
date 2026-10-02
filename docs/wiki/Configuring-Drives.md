# Configuring Drives & Storage Providers ☁️

UnifyCloud connects to a wide variety of cloud and on-premise storage backends. This guide explains how to configure, connect, and manage each supported provider.

---

## 🧭 The "Add Cloud" Dialog

To connect a new storage account:
1. Open UnifyCloud and navigate to the **Home** screen.
2. Tap the **"+ Add Cloud"** button (or Floating Action Button on mobile).
3. The **Add Cloud Account** dialog will open.
4. Select your provider type from the dropdown list.
5. Provide a friendly name (e.g., `WorkDrive`, `PersonalDropbox`, `HomeNAS`).
6. Complete the provider-specific credentials described below.
7. Tap **Save & Connect**. UnifyCloud will test the connection, fetch storage quota, encrypt credentials in the platform Keyring, and add the drive card to your dashboard.

---

## 1. 📁 Google Drive

Google Drive integration supports full file browsing, upload, download, streaming, and direct cloud-to-cloud transfers.

### Connection Steps:
1. Select **Google Drive** in the provider selector.
2. Choose your **Authentication Mode**:
   - **UnifyCloud (Official / Recommended)**: Instant one-click login using verified UnifyCloud credentials.
   - **Rclone (Fallback)**: Historical default keys.
   - **Personal Client ID (Advanced)**: For power users with their own Google Cloud Console credentials. (See [OAuth Setup Guide](OAuth-Setup-Guide#1-google-drive-setup)).
3. Tap **Launch Browser Sign-In**.
4. UnifyCloud spins up an ephemeral local loopback server on port `53682` and opens your default browser.
5. Log in with your Google account and grant permissions to access Drive files.
6. Once authorized, the browser will automatically redirect back to `http://127.0.0.1:53682/` with a success page: *"UnifyCloud - Authentication Successful! You can close this tab."*
7. UnifyCloud captures the OAuth token and saves the remote.

> [!TIP]
> If you are using a **Personal Client ID**, Google may display a prompt saying *"Google hasn't verified this app"*. Click **Advanced** (bottom left) ➔ **Go to UnifyCloud (unsafe)** to complete authorization.

---

## 2. 🏢 Microsoft OneDrive

Supports personal Microsoft accounts (`@outlook.com`, `@hotmail.com`) as well as business, university, and school tenants (**Microsoft 365 / SharePoint**).

### Connection Steps:
1. Select **Microsoft OneDrive**.
2. Choose between **UnifyCloud Official** or **Personal Client ID** (see [OAuth Setup Guide](OAuth-Setup-Guide#2-microsoft-onedrive-setup)).
3. Tap **Launch Browser Sign-In**.
4. Authorize the application on the Microsoft login page.
5. **Intelligent Drive Discovery**: Once authenticated, UnifyCloud queries the Microsoft Graph API (`/v1.0/me/drive`) to automatically identify your `drive_id` and whether the account is `personal` or `business`.
6. Tap **Save & Connect**.

---

## 3. 📦 Dropbox

Supports individual Dropbox accounts and Dropbox Business folders.

### Connection Steps:
1. Select **Dropbox**.
2. Select your auth mode (Default or Personal App Key).
3. Tap **Launch Browser Sign-In**.
4. Log in to Dropbox and grant file read/write permissions.
5. The local callback captures your access and refresh tokens.
6. Tap **Save & Connect**.

---

## 4. 🌐 Nextcloud / WebDAV

Nextcloud, ownCloud, and any generic WebDAV-compliant server (such as Box WebDAV, Koofr, or cPanel WebDAV) can be mounted seamlessly.

### Required Fields:
| Field | Example / Description |
|---|---|
| **Remote Name** | `MyNextcloud` |
| **Server URL** | `https://cloud.mycompany.com/remote.php/dav/files/myuser/` |
| **Username** | Your Nextcloud username |
| **Password** | Your Nextcloud account password or **App Password** *(Recommended)* |
| **Vendor Type** | Auto-detected (or `nextcloud` / `owncloud` / `other`) |

> [!IMPORTANT]
> **Nextcloud App Password Recommendation**:
> If your Nextcloud instance has Two-Factor Authentication (2FA) enabled or you want enhanced security, do not use your main login password. Instead:
> 1. In Nextcloud Web, go to **Personal Settings** ➔ **Security**.
> 2. Scroll to **Devices & client tokens**.
> 3. Enter `UnifyCloud` and click **Create new app password**.
> 4. Use the generated token in the Password field in UnifyCloud.

---

## 5. 🖥️ SSH / SFTP

Connect directly to remote Linux servers, home lab machines, VPS instances, or NAS appliances via secure SSH File Transfer Protocol.

### Required Fields:
| Field | Example / Description |
|---|---|
| **Remote Name** | `HomeNAS` or `ProdServer` |
| **Host** | `192.168.1.100` or `nas.local` or `vps.example.com` |
| **Port** | `22` (default SSH port) |
| **Username** | `root` or `ubuntu` or `admin` |
| **Password** | Password for the remote user |
| **Root Path** | Optional starting path (e.g. `/var/www` or `/home/user/storage`). Leave blank for user root. |

---

## 6. 🪣 Amazon S3 & S3-Compatible (MinIO, Wasabi, Backblaze)

Supports standard AWS S3 as well as all enterprise and open-source S3-compatible object stores (MinIO, Wasabi, Backblaze B2 S3 API, Cloudflare R2, Scaleway, DigitalOcean Spaces).

### Required Fields:
| Field | Standard AWS S3 | S3-Compatible (e.g., MinIO / Backblaze) |
|---|---|---|
| **Endpoint URL** | *(Leave blank)* | `https://s3.us-west-002.backblazeb2.com` or `http://192.168.1.50:9000` |
| **Access Key ID** | `AKIAIOSFODNN7EXAMPLE` | Access Key provided by your storage provider |
| **Secret Access Key** | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` | Secret Key provided by your storage provider |
| **Bucket / Root Path** | *(Optional)* e.g. `my-backup-bucket` | Target bucket name |
| **Region** | e.g. `us-east-1` or `eu-central-1` | S3 region specified by provider |

---

## 7. 💾 Local Filesystem

UnifyCloud treats your device's local drive as a first-class storage provider. This allows you to explore local files and initiate seamless transfers or synchronization between your physical device and any cloud service.

### Default Local Paths:
- **Android**: `/storage/emulated/0` (Primary Shared External Storage)
- **Linux & macOS**: `/` (Root directory) or user home `~/`
- **Windows**: `C:\` or any secondary drive letter (`D:\`, `E:\`)

### Quota Detection:
UnifyCloud calls native OS disk interrogation to report total physical storage space and remaining free disk space directly on the Home dashboard.

---

## 8. 🔒 End-to-End Encryption Vaults (Rclone Crypt)

**Crypt** allows you to create a 100% zero-knowledge, client-side encrypted vault on top of ANY cloud drive or local folder.

```mermaid
flowchart LR
    A[UnifyCloud Vault<br>Plaintext view in app] <==>|Client-Side AES-256| B[Go Crypt Engine<br>Encrypts content & file names]
    B <==> C[Underlying Cloud Remote<br>e.g. GoogleDrive:EncryptedFolder]
```

### Why Use Crypt?
- **Zero-Knowledge Privacy**: The cloud provider (Google, Microsoft, Dropbox) only sees scrambled binary blocks. They cannot read your documents, inspect photos, or perform automated scanning.
- **Encrypted File & Folder Names**: File names (e.g., `tax_return_2025.pdf`) are transformed into randomized hashes (e.g., `7h2k9s...`).
- **Standard Rclone Crypt Compatibility**: The encrypted vault created in UnifyCloud can be opened anywhere using the official standard Rclone CLI (`rclone mount` / `rclone copy`) on any computer using the same password and salt!

### How to Create an Encrypted Vault:
1. Tap **+ Add Cloud** and select **Crittografia E2E (Crypt)**.
2. **Target Remote**: Select which cloud account and folder will host the scrambled data (e.g. `GoogleDrive:SecureVault` or `Dropbox:Backups`).
3. **Password**: Choose a strong master passphrase.
4. **Salt (Optional but Recommended)**: Enter a secondary passphrase for key-derivation hardening.
5. **Filename Encryption**:
   - `standard` (Recommended): Encrypts file names into randomized strings.
   - `obfuscate`: Replaces file names with reversible phonetic characters.
   - `off`: Keeps original file names, encrypting file contents only.
6. **Directory Name Encryption**: Toggle ON to hide folder names.
7. Tap **Save & Connect**.

> [!CAUTION]
> **There is NO password recovery for Crypt vaults.** If you lose your password and salt, your data cannot be recovered by anyone, including the UnifyCloud team or your cloud provider. Store your password safely in a password manager.

---

## ⚙️ Managing Existing Remotes

On the **Home** dashboard:

- **Storage Meter**: Each card displays used space, total capacity, and a colored utilization bar.
- **Refresh Quota**: Tap the refresh icon on any card to query updated quota statistics.
- **Browse Files**: Tap anywhere on a drive card to launch the **File Explorer** for that remote.
- **Context Options (3-Dots Menu)**:
  - **Dettagli / Verifica (Verify Connection)**: Interrogates remote health.
  - **Rinomina (Rename)**: Updates the display name of the remote.
  - **Disconnetti (Remove / Delete Remote)**:
    - Safely unbinds the remote from UnifyCloud.
    - Clears encrypted tokens and configs from the OS Keychain.
    - **Never deletes files on the actual cloud server.**
