#!/usr/bin/env bash
#
# Arch-Hyprland-Dotfiles uninstaller
# Removes configs and helper scripts installed by install.sh
#
# Usage:
#   ./uninstall.sh              Remove configs only
#   ./uninstall.sh --packages   Also remove packages from pkglist.txt
#   ./uninstall.sh --full       Remove packages from pkglist-full.txt
#   ./uninstall.sh --all        Remove configs + full package list
#
set -euo pipefail

CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"

REMOVE_PACKAGES=false
FULL=false

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
        --packages) REMOVE_PACKAGES=true ;;
        --full)     FULL=true ;;
        --all)      REMOVE_PACKAGES=true; FULL=true ;;
        -h|--help)  sed -n '2,12p' "${BASH_SOURCE[0]}" ; exit 0 ;;
        *)          die "Unknown argument: $arg (run ./uninstall.sh --help)" ;;
    esac
done

# ---------------------------------------------------------------------------
# Confirm before destructive action
# ---------------------------------------------------------------------------
echo -e "${C_YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
echo -e "${C_YELLOW}  Arch-Hyprland-Dotfiles UNINSTALLER${C_RESET}"
echo -e "${C_YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
echo
warn "This will remove the following configs from ~/.config/:"
echo "  hypr waybar kitty rofi swaync fastfetch gtk-3.0 gtk-4.0"
echo "  Thunar autostart nwg-look swayosd cava OpenRGB"
echo "  spicetify spotify kate"
echo
warn "And helper scripts from ~/.local/bin/:"
echo "  toggle-waybar wallpaper-switcher.sh"
echo

if [ "$REMOVE_PACKAGES" = "true" ]; then
    warn "And UNINSTALL packages from pkglist.txt"
    [ "$FULL" = "true" ] && warn "And UNINSTALL packages from pkglist-full.txt"
fi

echo
read -p "Continue? [y/N] " confirm
case "$confirm" in
    [yY]|[yY][eE][sS]) ;;
    *) die "Aborted." ;;
esac

# ---------------------------------------------------------------------------
# Remove configs
# ---------------------------------------------------------------------------
remove_configs() {
    local dirs=(hypr waybar kitty rofi swaync fastfetch gtk-3.0 gtk-4.0 Thunar
                autostart nwg-look swayosd cava OpenRGB spicetify
                spotify kate)
    for d in "${dirs[@]}"; do
        if [ -d "$CONFIG_DIR/$d" ]; then
            rm -rf "$CONFIG_DIR/$d"
            ok "Removed: ~/.config/$d"
        else
            warn "Not found: ~/.config/$d"
        fi
    done
}

# ---------------------------------------------------------------------------
# Remove helper scripts
# ---------------------------------------------------------------------------
remove_helpers() {
    local scripts=(toggle-waybar wallpaper-switcher.sh)
    for s in "${scripts[@]}"; do
        if [ -f "$LOCAL_BIN/$s" ]; then
            rm -f "$LOCAL_BIN/$s"
            ok "Removed: ~/.local/bin/$s"
        fi
    done
}

# ---------------------------------------------------------------------------
# Remove packages
# ---------------------------------------------------------------------------
remove_packages() {
    local list_file="$1"
    local pkgs
    pkgs="$(grep -vE '^\s*(#|$)' "$list_file" | tr '\n' ' ')"
    [ -z "$pkgs" ] && return 0

    info "Removing packages from $list_file ..."
    echo "Packages to remove: $pkgs"
    read -p "Continue removing packages? [y/N] " confirm_pkg
    case "$confirm_pkg" in
        [yY]|[yY][eE][sS])
            sudo pacman -Rns --noconfirm $pkgs 2>/dev/null || \
                warn "Some packages could not be removed (they may have dependencies)"
            ok "Package removal complete."
            ;;
        *) warn "Skipped package removal." ;;
    esac
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
info "Removing configs..."
remove_configs

info "Removing helper scripts..."
remove_helpers

if [ "$REMOVE_PACKAGES" = "true" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    remove_packages "$SCRIPT_DIR/pkglist.txt"
    [ "$FULL" = "true" ] && remove_packages "$SCRIPT_DIR/pkglist-full.txt"
fi

echo
echo -e "${C_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
echo -e "${C_GREEN}✓ Uninstall complete!${C_RESET}"
echo -e "${C_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
