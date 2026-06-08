#!/usr/bin/env bash
# install.sh — Post-install Arch/Hyprland — michkaroma
# Prérequis : archinstall minimal (btrfs, systemd-boot, NetworkManager)
# Usage : git clone git@github.com:michkaroma/Hyprland-Michka.git ~/dotfiles
#         cd ~/dotfiles && ./install.sh
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_PACKAGES=(bash firefox git hypridle hyprland hyprlock hyprmocha hyprpaper kitty mimeapps starship waybar fastfetch wofi)
SDDM_THEME_REPO="https://github.com/michkaroma/SDDM-Michka.git"
SDDM_THEME_NAME="SDDM-Michka"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

# === 1. Paquets officiels ===
echo "==> [1/8] Paquets officiels"
sudo pacman -S --needed - < "$DOTFILES_DIR/telechargements.txt"

# === 2. yay ===
if ! command -v yay &>/dev/null; then
    echo "==> [2/8] Installation de yay"
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si)
    rm -rf /tmp/yay
else
    echo "==> [2/8] yay déjà présent"
fi

# === 3. Paquets AUR ===
echo "==> [3/8] Paquets AUR"
yay -S --needed visual-studio-code-bin beeper-bin

# === 4. Dotfiles ===
echo "==> [4/8] Stow des dotfiles"
cd "$DOTFILES_DIR"

FIREFOX_DIR="$HOME/.config/mozilla/firefox"

# --- 4a. Backup des anciens profils Firefox (*.default-release, *.default) ---
if [ -d "$FIREFOX_DIR" ]; then
    for profile in "$FIREFOX_DIR"/*.default-release "$FIREFOX_DIR"/*.default; do
        [ -d "$profile" ] || continue
        mkdir -p "$BACKUP_DIR/firefox-profiles"
        mv "$profile" "$BACKUP_DIR/firefox-profiles/"
        echo "   -> profil Firefox sauvegardé : $(basename "$profile")"
    done
fi

# --- 4b. Pré-créer l'arborescence du profil pour empêcher le folding stow ---
mkdir -p "$FIREFOX_DIR/michka.default-release/chrome"

# --- 4c. Backup des fichiers en conflit (vrais fichiers, pas symlinks) ---
for pkg in "${STOW_PACKAGES[@]}"; do
    while IFS= read -r -d '' file; do
        target="$HOME/${file#"$pkg"/}"
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            mkdir -p "$BACKUP_DIR/$(dirname "${file#"$pkg"/}")"
            mv "$target" "$BACKUP_DIR/${file#"$pkg"/}"
            echo "   -> conflit sauvegardé : $target"
        fi
    done < <(find "$pkg" -type f -print0)
done

stow -R "${STOW_PACKAGES[@]}"
[ -d "$BACKUP_DIR" ] && echo "   (sauvegardes dans $BACKUP_DIR)"

# --- 4d. Arkenfox : user.js + updater.sh dans le profil ---
echo "==> [4d] Arkenfox"
ARKENFOX_PROFILE="$FIREFOX_DIR/michka.default-release"
for f in user.js updater.sh; do
    wget -q "https://raw.githubusercontent.com/arkenfox/user.js/master/$f" -O "$ARKENFOX_PROFILE/$f"
done
chmod +x "$ARKENFOX_PROFILE/updater.sh"
"$ARKENFOX_PROFILE/updater.sh" -s

# === 5. Thème SDDM ===
echo "==> [5/8] Thème SDDM"
if [ ! -d "/usr/share/sddm/themes/$SDDM_THEME_NAME" ]; then
    sudo git clone "$SDDM_THEME_REPO" "/usr/share/sddm/themes/$SDDM_THEME_NAME"
fi
sudo mkdir -p /etc/sddm.conf.d
printf '[Theme]\nCurrent=%s\n' "$SDDM_THEME_NAME" | sudo tee /etc/sddm.conf.d/theme.conf >/dev/null

# === 6. PAM gnome-keyring ===
echo "==> [6/8] PAM keyring"
for pamfile in /etc/pam.d/login /etc/pam.d/sddm; do
    if ! sudo grep -q pam_gnome_keyring "$pamfile"; then
        echo "auth       optional     pam_gnome_keyring.so" | sudo tee -a "$pamfile" >/dev/null
        echo "session    optional     pam_gnome_keyring.so auto_start" | sudo tee -a "$pamfile" >/dev/null
        echo "   -> $pamfile modifié"
    fi
done

# === 7. Services ===
echo "==> [7/8] Services systemd"
sudo systemctl enable sddm NetworkManager bluetooth tailscaled

# === 8. Divers ===
echo "==> [8/8] Navigateur par défaut"
xdg-settings set default-web-browser firefox.desktop 2>/dev/null || true

cat <<'EOF'

╔════════════════════════════════════════════════════╗
║              ÉTAPES MANUELLES RESTANTES            ║
╠════════════════════════════════════════════════════╣
║ 1. ~/.ssh : restaurer + chmod 700/600              ║
║ 2. /var/lib/sbctl : restaurer les clés             ║
║    (GUID et keys/ DIRECTEMENT dans /var/lib/sbctl) ║
║ 3. NVIDIA : nvidia_drm.modeset=1 dans              ║
║    /etc/kernel/cmdline puis: sudo mkinitcpio -P    ║
║ 4. rEFInd : maj 'volume' (PARTUUID nouvelle ESP)   ║
║    dans refind.conf -> lsblk -o NAME,PARTUUID      ║
║ 5. sbctl sign : bootmgfw.efi (rEFInd),             ║
║    systemd-bootx64.efi, BOOTX64.EFI                ║
║ 6. efibootmgr -o ... (rEFInd en premier)           ║
║ 7. Secure Boot : réactiver dans le BIOS            ║
║ 8. sudo tailscale up                               ║
║ 9. Reconnecter : Nextcloud, Firefox Sync, Beeper   ║
║10. Reboot !                                        ║
╚════════════════════════════════════════════════════╝
EOF
