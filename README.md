# Arch-Hyprland-Dotfiles

My personal Hyprland desktop configuration for Arch Linux. Modular, themeable, and reproducible across machines.

## What's Included

| Component | Description |
|-----------|-------------|
| **Hyprland** | Modular config split into `colors/` and `modules/` (monitors, keybinds, autostart, etc.) |
| **Waybar** | Status bar with custom scripts (network speed, controller battery, brightness) |
| **Rofi** | App launcher, emoji picker, power menu, clipboard history |
| **Kitty** | Terminal with JetBrains Mono Nerd Font and Catppuccin theming |
| **SwayNC** | Notification center |
| **SwayOSD** | On-screen display for volume/brightness |
| **Fastfetch** | System info fetch tool |
| **OpenRGB** | RGB lighting profile (Catppuccin) |
| **Cava** | Terminal audio visualizer |

## Quick Start

```bash
# Clone and run the installer
git clone https://github.com/syrax-dev/Arch-Hyprland-Dotfiles.git
cd Arch-Hyprland-Dotfiles
./install.sh
```

The installer will:
1. Install all required packages (from `pkglist.txt`) using your AUR helper
2. Link all configs from the repo into `~/.config/`

### Installer Options

| Flag | Effect |
|------|--------|
| `--full` | Also install the full package list (`pkglist-full.txt` — all 164 explicit packages from my system) |
| `--no-packages` | Skip package installation, only link configs |
| `--services` | Enable NetworkManager, Bluetooth, SDDM, reflector, tuned |

## Requirements

- Arch Linux or Arch-based distro (Manjaro, EndeavourOS, CachyOS)
- An AUR helper: `yay` (preferred) or `paru`
- (Optional) SDDM for display manager login

The installer will install `yay` automatically if neither is present.

## Directory Structure

```
.
├── install.sh          # Main installer script
├── pkglist.txt         # Core packages for the Hyprland setup
├── pkglist-full.txt    # All explicit packages from the source system
│
├── hypr/               # Hyprland config (modular)
│   ├── hyprland.conf   # Main entry point (sources all modules)
│   ├── hypridle.conf   # Idle daemon config
│   ├── hyprlock.conf   # Lock screen config
│   ├── colors/         # Color schemes (catppuccin.conf)
│   └── modules/        # Split configs (keybinds, autostart, etc.)
│
├── waybar/             # Status bar
│   ├── config.jsonc    # Bar modules
│   ├── style.css       # Catppuccin-themed styling
│   ├── colors/         # Additional color schemes
│   └── scripts/        # Custom modules (network-speed, brightness, etc.)
│
├── kitty/              # Terminal emulator
│   └── kitty.conf      # Font, padding, theme include
│
├── rofi/               # Launcher and menus
│   ├── config.rasi     # App launcher theme
│   ├── powermenu.rasi  # Power menu theme
│   ├── clipboard.sh    # Clipboard history script
│   └── powermenu.sh    # Power menu script
│
├── swaync/             # Notification center
├── swayosd/            # Volume/brightness OSD
├── fastfetch/          # System info
├── cava/               # Audio visualizer
├── OpenRGB/            # RGB profile
├── spicetify/          # Spotify theming
├── spotify/            # Spotify prefs (saved login state)
├── Thunar/             # File manager actions
├── gtk-3.0/            # GTK 3 theme settings
├── gtk-4.0/            # GTK 4 theme settings
├── autostart/          # XDG autostart entries
├── nwg-look/           # GTK theme switcher
├── kate/               # Kate editor external tools
└── local/bin/          # Helper scripts (toggle-waybar, wallpaper-switcher)
```

## Keybindings

| Binding | Action |
|---------|--------|
| `SUPER + Return` | Open Kitty terminal |
| `SUPER + E` | Open Thunar file manager |
| `SUPER + A` | Open Rofi app launcher |
| `SUPER + B` | Open Zen Browser |
| `SUPER + SHIFT + B` | Open Firefox |
| `SUPER + W` | Cycle wallpapers |
| `SUPER + M` | Toggle Waybar |
| `SUPER + L` | Lock screen (hyprlock) |
| `SUPER + Q` | Close active window |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + V` | Toggle floating |
| `SUPER + Print` | Screenshot full screen |
| `SHIFT + Print` | Screenshot selection |
| `SUPER + N` | Clipboard history (rofi) |

### Workspace Navigation

| Binding | Action |
|---------|--------|
| `SUPER + [1-0]` | Switch to workspace 1-10 |
| `SUPER + SHIFT + [1-0]` | Move window to workspace |
| `SUPER + S` | Toggle special workspace |
| `SUPER + [ / ]` | Navigate workspaces left/right |

### Audio & Brightness

| Binding | Action |
|---------|--------|
| `Volume Up/Down` | Adjust volume (swayosd) |
| `Mute` | Toggle mute |
| `Brightness Up/Down` | Adjust brightness (swayosd) |

## Wallpaper Management

Place wallpapers in `~/Pictures/Wallpapers/`. Press `SUPER + W` to cycle through them with random transitions. The wallpaper switcher script (`~/.local/bin/wallpaper-switcher.sh`) uses `swww` for smooth transitions.

## Optional Extras

These are referenced by the autostart config but not installed by the script:

| App | Install |
|-----|---------|
| ActivityWatch | Download from [activitywatch.net](https://activitywatch.net/), unpack to `/opt/activitywatch` |
| OmniRoute | Install the `omniroute` binary to your PATH |
| Dropbox | `yay -S dropbox` and sign in |

## Post-Install Checklist

- [ ] Start Hyprland: `uwsm start hyprland` (or select in SDDM)
- [ ] Add wallpapers to `~/Pictures/Wallpapers/`
- [ ] Sign into Spotify (if using) — Spicetify themes apply automatically
- [ ] Configure monitors: edit `~/.config/hypr/modules/monitors.conf`

## Troubleshooting

**Waybar doesn't start:** Check the config with `waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css`. Ensure `jq` is installed.

**Screenshots don't work:** Ensure `grim`, `slurp`, and `wl-clipboard` are installed.

**Audio controls don't work:** Ensure `swayosd` is running (`swayosd-server`). The autostart config handles this.

## License

This is a personal dotfiles repo. Use at your own risk. Feel free to fork and adapt.
