# UnifyCloud Documentation 📚

Welcome to the **UnifyCloud** documentation directory.

## 📖 GitLab Wiki Documentation (`docs/wiki/`)
The complete, production-ready English wiki documentation is structured and formatted for **GitLab Wiki** inside [`docs/wiki/`](./wiki/):

- **[`home.md`](./wiki/home.md)**: Main wiki landing page, architecture overview, supported clouds, and key capabilities.
- **[`Installation-Guide.md`](./wiki/Installation-Guide.md)**: Installation across Android (F-Droid & APKs), Linux (Flatpak & bundle), Windows, macOS, iOS, plus building from source.
- **[`Configuring-Drives.md`](./wiki/Configuring-Drives.md)**: Connecting and configuring Google Drive, OneDrive, Dropbox, Nextcloud/WebDAV, SFTP, Amazon S3, Local Disk, and Crypt E2EE vaults.
- **[`OAuth-Setup-Guide.md`](./wiki/OAuth-Setup-Guide.md)**: Complete guide to creating custom OAuth2 Client IDs & Secrets on Google Cloud Console, Microsoft Azure (Entra ID), and Dropbox Developer Console.
- **[`Setting-up-Sync.md`](./wiki/Setting-up-Sync.md)**: Detailed guide for configuring automated background folder synchronization, schedules, and difference between `copy` (backup) vs `sync` (mirror).
- **[`File-Management-and-Transfers.md`](./wiki/File-Management-and-Transfers.md)**: File explorer navigation, Dual-Pane Commander Mode, direct cloud-to-cloud streaming, clipboard, and real-time transfer manager.
- **[`Security-and-App-Lock.md`](./wiki/Security-and-App-Lock.md)**: Zero-plaintext in-RAM security architecture, OS keystores, PIN / Biometric App Lock, and AES-256 Crypt mechanics.
- **[`Troubleshooting-and-FAQ.md`](./wiki/Troubleshooting-and-FAQ.md)**: Common error resolutions, port conflicts, platform edge cases, and FAQ.
- **[`_sidebar.md`](./wiki/_sidebar.md)**: Navigation sidebar for the GitLab Wiki interface.
- **[`push_to_gitlab_wiki.sh`](./wiki/push_to_gitlab_wiki.sh)**: Automated shell script to clone and push this wiki directly to GitLab.

### Publishing to GitLab Wiki
To publish all docs to your GitLab Wiki in one command:
```bash
bash docs/wiki/push_to_gitlab_wiki.sh
```

---

## 📂 Additional Internal Guides
- **[`oauth_setup_guide.md`](./oauth_setup_guide.md)**: Original Italian guide for OAuth credentials setup.
- **[`wireframes.md`](./wireframes.md)**: Initial UI wireframe specifications and component diagrams.
