#!/usr/bin/env bash
set -e

# ==============================================================================
# UnifyCloud Flatpak Packaging Script
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "==> [1/4] Building Go CGO shared library (librclone_wrapper.so)..."
cd "$PROJECT_ROOT/go_backend"
go build -ldflags="-s -w" -buildmode=c-shared -o librclone_wrapper.so main.go

echo "==> [2/4] Building Flutter Linux Release bundle..."
cd "$PROJECT_ROOT"
flutter build linux --release

echo "==> [3/4] Ensuring librclone_wrapper.so is in the Linux bundle..."
cp -f "$PROJECT_ROOT/go_backend/librclone_wrapper.so" "$PROJECT_ROOT/build/linux/x64/release/bundle/lib/"

echo "==> [4/4] Verifying Flatpak tools..."
cd "$SCRIPT_DIR"

if ! command -v flatpak-builder &> /dev/null; then
    echo "----------------------------------------------------------------------"
    echo "AVVISO: 'flatpak-builder' non è installato in questo container."
    echo ""
    echo "Per installarlo sulla tua macchina host (Fedora/Silverblue/Ubuntu):"
    echo "  Fedora: sudo dnf install flatpak-builder"
    echo "  Ubuntu/Debian: sudo apt install flatpak-builder"
    echo ""
    echo "Poi esegui direttamente da terminale (nella cartella packaging/flatpak):"
    echo "  flatpak-builder --user --install --force-clean build-dir com.example.unifycloud.yml"
    echo ""
    echo "Oppure per generare un pacchetto singolo .flatpak standalone:"
    echo "  flatpak-builder --force-clean build-dir com.example.unifycloud.yml --repo=repo"
    echo "  flatpak build-bundle repo unifycloud.flatpak com.example.unifycloud"
    echo "----------------------------------------------------------------------"
    exit 0
fi

echo "==> Compilazione pacchetto Flatpak con flatpak-builder..."
flatpak-builder --user --install --force-clean build-dir com.example.unifycloud.yml

echo "==> Creazione bundle esportabile standalone (unifycloud.flatpak)..."
flatpak-builder --force-clean build-dir com.example.unifycloud.yml --repo=repo
flatpak build-bundle repo unifycloud.flatpak com.example.unifycloud

echo "==> Successo! Pacchetto Flatpak pronto:"
echo "    - Installato localmente nell'ambiente Flatpak utente: flatpak run com.example.unifycloud"
echo "    - File bundle autonomo generato: $SCRIPT_DIR/unifycloud.flatpak"

