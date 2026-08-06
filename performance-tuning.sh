#!/usr/bin/env bash
#
# Performance tuning script for Arch Linux
# Applies CPU governor, sysctl tweaks, and tuned profile for low-latency desktop
#
# This is NOT run by install.sh — run it manually:
#   sudo ./performance-tuning.sh
#
# What it does:
#   - Sets CPU governor to 'performance'
#   - Installs and enables tuned daemon with latency-performance profile
#   - Applies sysctl tweaks for memory and scheduling
#   - Configures zram (half of RAM, zstd compression)
#
# Requires: sudo
#
set -euo pipefail

# ---------------------------------------------------------------------------
# Colored output
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
# Preflight
# ---------------------------------------------------------------------------
if [ "$(id -u)" -ne 0 ]; then
    die "Run this script with sudo: sudo ./performance-tuning.sh"
fi

if ! grep -qEi 'ID=arch|ID=manjaro|ID=cachyos|ID=endeavouros' /etc/os-release 2>/dev/null; then
    die "This script is written for Arch Linux and Arch-based distros only."
fi

# ---------------------------------------------------------------------------
# 1. CPU Governor — performance
# ---------------------------------------------------------------------------
info "Setting CPU governor to 'performance'..."

# Install cpupower if not present
if ! pacman -Q cpupower >/dev/null 2>&1; then
    pacman -S --needed --noconfirm cpupower
fi

# Configure cpupower
cat > /etc/default/cpupower << 'EOF'
# CPU frequency governor settings
governor='performance'
EOF

# Enable cpupower service
systemctl enable --now cpupower.service 2>/dev/null || true

# Apply immediately
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo "performance" > "$cpu" 2>/dev/null || true
done

ok "CPU governor set to performance"

# ---------------------------------------------------------------------------
# 2. Tuned daemon — latency-performance profile
# ---------------------------------------------------------------------------
info "Configuring tuned daemon..."

# Install tuned if not present
if ! pacman -Q tuned >/dev/null 2>&1; then
    pacman -S --needed --noconfirm tuned
fi

# Enable tuned
systemctl enable --now tuned

# Set profile
tuned-adm profile latency-performance

ok "Tuned profile set to latency-performance"

# ---------------------------------------------------------------------------
# 3. Sysctl tuning — memory, scheduling
# ---------------------------------------------------------------------------
info "Applying sysctl tweaks..."

cat > /etc/sysctl.d/99-performance.conf << 'EOF'
# Performance tuning for desktop / development workstation
# Memory and swap behavior
vm.swappiness=5
vm.vfs_cache_pressure=50
vm.dirty_ratio=15
vm.dirty_background_ratio=5
vm.overcommit_memory=1
vm.overcommit_ratio=100
vm.max_map_count=524288

# Scheduler
kernel.sched_autogroup_enabled=1

# Process/thread limits (for high-load workloads)
kernel.pid_max=4194304
kernel.threads-max=4194304

# Shared memory (for databases, large apps)
kernel.shmmax=68719476736
kernel.shmall=4294967296
EOF

# Apply immediately
sysctl --system >/dev/null 2>&1

ok "Sysctl tweaks applied"

# ---------------------------------------------------------------------------
# 4. Zram configuration
# ---------------------------------------------------------------------------
info "Configuring zram..."

cat > /etc/systemd/zram-generator.conf << 'EOF'
[zram0]
# Use half of RAM for zram
zram-size = ram / 2
compression-algorithm = zstd
EOF

# Enable zram
systemctl daemon-reload
systemctl enable --now systemd-zram-setup@zram0.service 2>/dev/null || true

ok "Zram configured (50% of RAM, zstd)"

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo
echo -e "${C_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
echo -e "${C_GREEN}✓ Performance tuning complete!${C_RESET}"
echo -e "${C_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
echo
echo "Applied settings:"
echo "  - CPU governor: performance"
echo "  - Tuned profile: latency-performance"
echo "  - Sysctl: vm.swappiness=5, vfs_cache_pressure=50, dirty_ratio=15"
echo "  - Zram: 50% of RAM, zstd compression"
echo
echo "To revert, remove the files and reboot:"
echo "  sudo rm /etc/default/cpupower"
echo "  sudo rm /etc/sysctl.d/99-performance.conf"
echo "  sudo rm /etc/systemd/zram-generator.conf"
echo "  sudo systemctl disable --now tuned cpupower"
