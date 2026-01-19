#!/usr/bin/env bash

# Export Nix path so we find qutebrowser/swaymsg
export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/usr/local/bin:$PATH"

# Apply software rendering when we are in Sway
if [ -n "${SWAYSOCK:-}" ]; then
    export QT_QUICK_BACKEND=software
fi

set -eu

# Configuration
PERS_FILE="${PERS_FILE:-$HOME/.config/bookmarks/personal.txt}"
WORK_FILE="${WORK_FILE:-$HOME/.config/bookmarks/work.txt}"
BOOKMARKS_CONF="${WOFICONF:-$HOME/.config/wofi/bookmarks-menu.conf}"

# Wofi command
WOFI="wofi --conf='$BOOKMARKS_CONF' -p 'Bookmarks:' -i"

# Browsers & IDs
QUTE_CMD="$(command -v qutebrowser || true)"
QUTE_ID="org.qutebrowser.qutebrowser"

BRAVE_CMD="$(command -v brave || command -v brave-browser || true)"
# Note: On Hyprland, check 'hyprctl clients' for the class name if this fails
BRAVE_ID="brave-browser" 

FALLBACK="$(command -v xdg-open || echo qutebrowser)"

# Ensure files exist
mkdir -p "$(dirname "$PERS_FILE")"
[ -f "$PERS_FILE" ] || cat >"$PERS_FILE" <<'EOF'
# personal
tonybtw :: https://tonybtw.com
https://youtube.com
EOF
[ -f "$WORK_FILE" ] || cat >"$WORK_FILE" <<'EOF'
# work
[docs] NixOS Manual :: https://nixos.org/manual/
EOF

emit() {
  tag="$1"; file="$2"
  [ -f "$file" ] || return 0
  grep -vE '^\s*(#|$)' "$file" | while IFS= read -r line; do
    case "$line" in
      *"::"*)
        lhs="${line%%::*}"; rhs="${line#*::}"
        lhs="$(printf '%s' "$lhs" | sed 's/[[:space:]]*$//')"
        rhs="$(printf '%s' "$rhs" | sed 's/^[[:space:]]*//')"
        printf '[%s] %s :: %s\n' "$tag" "$lhs" "$rhs"
        ;;
      *)
        printf '[%s] %s :: %s\n' "$tag" "$line" "$line"
        ;;
    esac
  done
}

# Build combined list
choice="$({
  emit personal "$PERS_FILE"
  emit work     "$WORK_FILE"
} | sort | eval "$WOFI" || true)"

[ -n "$choice" ] || exit 0

# Parse tag and raw URL
tag="${choice%%]*}"; tag="${tag#\[}"
raw="${choice##* :: }"

# Clean URL
raw="$(printf '%s' "$raw" \
  | sed -e 's/[[:space:]]\+#.*$//' -e 's/[[:space:]]\/\/.*$//' \
        -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

# Ensure scheme
case "$raw" in
  http://*|https://*|file://*|about:*|chrome:*) url="$raw" ;;
  *) url="https://$raw" ;;
esac

# --- RUN OR RAISE LOGIC ---
open_with() {
  app_id="$1"
  cmd="$2"
  target_url="$3"

  # If command wasn't found, log it and return
  if [ "$cmd" = "true" ] || [ -z "$cmd" ]; then 
    echo "Error: Browser command not found for ID: $app_id"
    return
  fi

  if [ "${XDG_CURRENT_DESKTOP:-}" = "Hyprland" ]; then
      # --- HYPRLAND LOGIC ---
      if hyprctl clients | grep -q "class: $app_id"; then
          hyprctl dispatch focuswindow "class:^$app_id$"
          nohup "$cmd" "$target_url" >/dev/null 2>&1 &
      else
          nohup "$cmd" "$target_url" >/dev/null 2>&1 &
      fi

  elif [ -n "${SWAYSOCK:-}" ]; then
      # --- SWAY LOGIC ---
      # Try to focus. If it returns 0 (success), window exists.
      if swaymsg "[app_id=\"$app_id\"] focus"; then
          nohup "$cmd" "$target_url" >/dev/null 2>&1 &
      else
          nohup "$cmd" "$target_url" >/dev/null 2>&1 &
      fi
  
  else
      # --- FALLBACK ---
      nohup "$cmd" "$target_url" >/dev/null 2>&1 &
  fi
  
  # Disown the process so it survives script exit
  disown
  exit 0
}

case "$tag" in
  personal) open_with "$QUTE_ID"  "$QUTE_CMD"  "$url" ;;
  work)     open_with "$BRAVE_ID" "$BRAVE_CMD" "$url" ;;
esac

# Fallback
nohup $FALLBACK "$url" >/dev/null 2>&1 &

