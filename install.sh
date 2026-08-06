#!/usr/bin/env bash
#
# Arch-Hyprland-Dotfiles installer
# https://github.com/syrax-dev/Arch-Hyprland-Dotfiles
#
# Installs packages and links all configs so you get the exact same
# Hyprland setup as the author's machine.
#
# Usage:
#   git clone https://github.com/syrax-dev/Arch-Hyprland-Dotfiles.git && cd Arch-Hyprland-Dotfiles
#   ./install.sh
#
#   ./install.sh --full            also install the full pkglist-full.txt (all 164 explicit pkgs)
#   ./install.sh --no-packages     skip package installation, only link configs
#   ./install.sh --services        enable NetworkManager, Bluetooth, SDDM, reflector, tuned
#
set -euo pipefail

REPO_URL="https://github.com/syrax-dev/Arch-Hyprland-Dotfiles.git"
REPO_DIR_CLONE="$HOME/Arch-Hyprland-Dotfiles"

FULL=false
NO_PACKAGES=false
ENABLE_SERVICES=false

# ---------------------------------------------------------------------------
# Colored output helpers
# ---------------------------------------------------------------------------
C_RESET='\033[0m'
C_CYAN='\033[0;36m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[1;33m'
C_RED='\033[0;31m'

info()  { echo -e "${C_CYAN}[*]${C_RESET} $*"; }
ok()    { echo -e "${C_GREEN}[+]${C_RESET} $*"; }
warn()  { echo -e "${C_YELLOW}[!]${C_RESET} $*"; }
die()   { echo -e "${C_RED}[x]${C_RESET} $*" >&2; exit 1; }

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
for arg in "$@"; do
    case "$arg" in
        --full)         FULL=true ;;
        --no-packages)  NO_PACKAGES=true ;;
        --services)     ENABLE_SERVICES=true ;;
        -h|--help)      sed -n '2,18p' "${BASH_SOURCE[0]}" ; exit 0 ;;
        *)              die "Unknown argument: $arg (run ./install.sh --help)" ;;
    esac
    shift
done

# ---------------------------------------------------------------------------
# Locate the repository directory.
# Works when run from a clone AND when piped in via curl | bash.
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -d "$SCRIPT_DIR/hypr" ]; then
    REPO_DIR="$SCRIPT_DIR"
else
    REPO_DIR="$REPO_DIR_CLONE"
    if [ ! -d "$REPO_DIR/.git" ]; then
        info "Running without a local repo, cloning to $REPO_DIR ..."
        git clone "$REPO_URL" "$REPO_DIR"
    fi
fi

CONFIG_DIR="$HOME/.config"

# ---------------------------------------------------------------------------
# Preflight checks
# ---------------------------------------------------------------------------
[ -n "${SUDO_USER:-}" ] && die "Do not run with sudo. Run as your normal user (you will be prompted for sudo)."
[ "$(id -u)" -eq 0 ]    && die "Do not run as root. Run as your normal user."

if ! grep -qEi 'ID=arch|ID=manjaro|ID=cachyos|ID=endeavouros' /etc/os-release 2>/dev/null; then
    die "This installer is written for Arch Linux and Arch-based distros only."
fi

command -v pacman >/dev/null 2>&1 || die "pacman not found. This is not an Arch-based system."

# ---------------------------------------------------------------------------
# 1. Ensure an AUR helper is present (yay preferred, paru acceptable)
# ---------------------------------------------------------------------------
ensure_aur_helper() {
    if command -v yay >/dev/null 2>&1; then
        AUR_HELPER="yay"
    elif command -v paru >/dev/null 2>&1; then
        AUR_HELPER="paru"
    else
        info "No AUR helper found. Installing yay (AUR) ..."
        sudo pacman -S --needed --noconfirm base-devel git
        mkdir -p "$HOME/.cache"
        git clone https://aur.archlinux.org/yay-bin.git "$HOME/.cache/yay-bin"
        ( cd "$HOME/.cache/yay-bin" && makepkg -si --noconfirm )
        AUR_HELPER="yay"
    fi
    ok "Using AUR helper: $AUR_HELPER"
}

install_packages() {
    local list_file="$1"
    local pkgs
    pkgs="$(grep -vE '^\s*(#|$)' "$REPO_DIR/$list_file" | tr '\n' ' ')"
    [ -z "$pkgs" ] && return 0
    info "Installing packages from $list_file ..."
    "$AUR_HELPER" -S --needed --noconfirm $pkgs
    ok "Packages installed."
}

# ---------------------------------------------------------------------------
# 2. Link configs from the repo into ~/.config
# ---------------------------------------------------------------------------
link_configs() {
    local dirs=(hypr waybar kitty rofi swaync fastfetch gtk-3.0 gtk-4.0 Thunar
                autostart nwg-look swayosd cava OpenRGB spicetify kate)
    for d in "${dirs[@]}"; do
        if [ -d "$REPO_DIR/$d" ]; then
            mkdir -p "$CONFIG_DIR/$d"
            rsync -a "$REPO_DIR/$d/" "$CONFIG_DIR/$d/"
            ok "Linked config: ~/.config/$d"
        fi
    done
    # spotify prefs (restores saved login state) are linked separately so they
    # can be skipped easily by deleting the line below.
    [ -d "$REPO_DIR/spotify" ] && rsync -a "$REPO_DIR/spotify/" "$CONFIG_DIR/spotify/"

    # helper scripts referenced by keybinds (toggle-waybar, wallpaper-switcher)
    mkdir -p "$HOME/.local/bin"
    for f in "$REPO_DIR"/local/bin/*; do
        [ -f "$f" ] && install -Dm755 "$f" "$HOME/.local/bin/$(basename "$f")" && ok "Installed helper: ~/.local/bin/$(basename "$f")"
    done
}

# ---------------------------------------------------------------------------
# 3. Create wallpaper dir
# ---------------------------------------------------------------------------
init_wallpapers() {
    local wall_dir="$HOME/Pictures/Wallpapers"
    mkdir -p "$wall_dir"
    if [ -z "$(find "$wall_dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.webp' \) 2>/dev/null)" ]; then
        warn "Wallpaper directory is empty: $wall_dir"
        warn "Drop some wallpapers in there — SUPER+W cycles through them."
    fi
}

# ---------------------------------------------------------------------------
# 4. Optional: enable system services
# ---------------------------------------------------------------------------
enable_services() {
    local services=(
        "NetworkManager" "bluetooth" "sddm" "reflector.timer" "tuned"
    )
    for s in "${services[@]}"; do
        if systemctl list-unit-files --type=service 2>/dev/null | grep -q "$s"; then
            sudo systemctl enable --now "$s" 2>/dev/null && ok "Enabled service: $s" || warn "Could not enable: $s"
        fi
    done
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
echo -e "${C_CYAN}  Arch-Hyprland-Dotfiles installer${C_RESET}"
echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"

if [ "$NO_PACKAGES" != "true" ]; then
    ensure_aur_helper
    install_packages "pkglist.txt"
    [ "$FULL" = "true" ] && install_packages "pkglist-full.txt"
else
    warn "Skipping package installation (--no-packages)."
fi

info "Linking configs ..."
link_configs

init_wallpapers

if [ "$ENABLE_SERVICES" = "true" ]; then
    info "Enabling services ..."
    enable_services
fi

echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
echo -e "${C_GREEN}✓ Installation complete!${C_RESET}"
echo
echo "Next steps:"
echo "  1. Start the session:  login to a TTY and run  uwsm start hyprland"
echo "     (or select Hyprland in your display manager)"
echo "  2. Set a wallpaper:     drop images in ~/Pictures/Wallpapers, press SUPER+W"
echo
echo "Manual / optional extras (not installed by this script):"
echo "  - ActivityWatch:  unpack to /opt/activitywatch (autostart expects it)"
echo "  - OmniRoute:      install the omniroute binary (autostart runs it)"
echo "  - Dropbox:        install + sign in (autostart runs it)"
echo "  - Spicetify:      themes are installed via 'spicetify marketplace'"
