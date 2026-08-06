#!/usr/bin/env bash

## Rofi Powermenu Script (WORKING)

dir="$HOME/.config/rofi"
theme="powermenu"

# -----------------------------
# Info
# -----------------------------
uptime="$(uptime -p | sed 's/up //g')"
host="$USER"

# -----------------------------
# Icons (Nerd Font)
# -----------------------------
shutdown='󰐥'
reboot='󰜉'
lock='󰌾'
suspend='󰤄'
logout='󰍃'
yes='󰄬'
no='󰅙'

# -----------------------------
# Rofi main menu
# -----------------------------
rofi_cmd() {
  rofi -dmenu \
    -p "$host" \
    -mesg "Uptime: $uptime" \
    -theme "${dir}/${theme}.rasi"
}

# -----------------------------
# Confirmation menu
# -----------------------------
confirm_cmd() {
  rofi -dmenu \
    -p "Confirmation" \
    -mesg "Are you sure?" \
    -theme "${dir}/shared/confirm.rasi"
}

confirm_exit() {
  echo -e "$yes\n$no" | confirm_cmd
}

# -----------------------------
# Show menu
# -----------------------------
run_rofi() {
  echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# -----------------------------
# Execute actions
# -----------------------------
run_cmd() {
  selected="$(confirm_exit)"

  if [[ "$selected" != "$yes" ]]; then
    exit 0
  fi

  case "$1" in
    --shutdown)
      systemctl poweroff
      ;;
    --reboot)
      systemctl reboot
      ;;
    --suspend)
      wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
      systemctl suspend
      ;;
    --logout)
      if [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]; then
        hyprctl dispatch exit
      elif [[ "$DESKTOP_SESSION" == "openbox" ]]; then
        openbox --exit
      elif [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
        bspc quit
      elif [[ "$DESKTOP_SESSION" == "i3" ]]; then
        i3-msg exit
      elif [[ "$DESKTOP_SESSION" == "plasma" ]]; then
        qdbus org.kde.ksmserver /KSMServer logout 0 0 0
      fi
      ;;
  esac
}

# -----------------------------
# Handle selection
# -----------------------------
chosen="$(run_rofi)"

case "$chosen" in
  $shutdown)
    run_cmd --shutdown
    ;;
  $reboot)
    run_cmd --reboot
    ;;
 $lock)
  if command -v hyprlock >/dev/null; then
    hyprlock
  elif command -v swaylock >/dev/null; then
    swaylock
  elif command -v i3lock >/dev/null; then
    i3lock
  fi
  ;;
  $suspend)
    run_cmd --suspend
    ;;
  $logout)
    run_cmd --logout
    ;;
esac
