# UnifyCloud Flatpak Packaging

Questa cartella contiene tutti i file necessari per pacchettizzare, distribuire e installare **UnifyCloud** in formato **Flatpak** per qualsiasi distribuzione Linux (Fedora, Ubuntu, Arch, openSUSE, Debian, SteamOS, Bazzite, ecc.).

---

## 1. File Inclusi

- [`com.example.unifycloud.yml`](./com.example.unifycloud.yml): Manifest per `flatpak-builder` con configurazione runtime `org.freedesktop.Platform 24.08`.
- [`com.example.unifycloud.desktop`](./com.example.unifycloud.desktop): File desktop entry conforme agli standard freedesktop (con categorie, mime types e scorciatoia nel launcher di sistema).
- [`com.example.unifycloud.metainfo.xml`](./com.example.unifycloud.metainfo.xml): Metadati AppStream per la visualizzazione su GNOME Software, KDE Discover e Flathub.
- [`com.example.unifycloud.png`](./com.example.unifycloud.png): Icona dell'applicazione a 256x256 px.
- [`build_flatpak.sh`](./build_flatpak.sh): Script di automazione per compilare il core Go, compilare la release Flutter Linux ed eseguire il packaging.

---

## 2. Permessi della Sandbox Flatpak (`finish-args`)

UnifyCloud è configurato con i permessi minimi indispensabili per operare come gestore file e client di backup cloud:

| Permesso | Scopo |
|---|---|
| `--share=network` | Necessario per la connessione alle API dei cloud provider (Google Drive, OneDrive, Dropbox, SFTP, WebDAV, S3) |
| `--socket=wayland` / `--socket=fallback-x11` | Rendering grafico nativo su display server Wayland e X11 |
| `--device=dri` | Accelerazione grafica hardware GPU (OpenGL / Vulkan) |
| `--filesystem=host` | Accesso al filesystem locale per esplorare, scaricare e sincronizzare cartelle (es. Foto, Documenti) |
| `--talk-name=org.freedesktop.portal.FileChooser` | Portale nativo per la selezione di file e cartelle del sistema |
| `--talk-name=org.freedesktop.portal.OpenURI` | Apertura di file con le applicazioni predefinite dell'host e link web |
| `--talk-name=org.freedesktop.secrets` | Cifratura e persistenza sicura dei token cloud tramite Secret Service / Keyring |

---

## 3. Come Compilare e Installare il Flatpak

### Prerequisiti sull'Host
Installa `flatpak` e `flatpak-builder`:
```bash
# Fedora / RHEL / Bazzite / Atomic Desktop:
sudo dnf install -y flatpak flatpak-builder

# Ubuntu / Debian / Pop!_OS:
sudo apt install -y flatpak flatpak-builder

# Arch Linux:
sudo pacman -S flatpak flatpak-builder
```

Installa il runtime e SDK di Freedesktop (versione 24.08):
```bash
flatpak install flathub org.freedesktop.Platform//24.08 org.freedesktop.Sdk//24.08
```

---

### Procedura Rapida di Compilazione (1 Comando)

Dalla root del progetto:
```bash
# 1. Compila la release Linux e la libreria CGO
flutter build linux --release

# 2. Compila e installa l'app come Flatpak per il tuo utente locale:
cd packaging/flatpak
flatpak-builder --user --install --force-clean build-dir com.example.unifycloud.yml
```

---

### Esecuzione dell'App Flatpak

Una volta installata, UnifyCloud compare automaticamente nel menu delle applicazioni del desktop (GNOME, KDE, Cinnamon, ecc.), oppure può essere avviata da terminale:
```bash
flatpak run com.example.unifycloud
```

---

### Creazione di un Pacchetto Standalone `.flatpak`

Per distribuire un singolo file `.flatpak` installabile su qualsiasi PC senza ricompilare:
```bash
cd packaging/flatpak

# Costruisci il repository locale
flatpak-builder --force-clean build-dir com.example.unifycloud.yml --repo=repo

# Esporta il bundle .flatpak
flatpak build-bundle repo unifycloud.flatpak com.example.unifycloud
```

Il file risultante `unifycloud.flatpak` può essere installato su qualsiasi sistema con un semplice doppio clic o da terminale:
```bash
flatpak install unifycloud.flatpak
```

