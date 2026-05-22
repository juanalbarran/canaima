# Theme System

Runtime dark/light switching across all apps using a shared Base16 color palette. Nix generates both variants at build time; a shell script switches between them at runtime without rebuilding.

## Directory Layout

```
themes/
├── dark.nix                  # Dark color palette (Base16)
├── light.nix                 # Light color palette (Base16)
├── default.nix               # Generates config files + exposes toggle-theme binary
├── gtk.nix                   # GTK/Qt declarative base theme (Adwaita)
├── scripts/
│   └── toggle-theme.sh       # Runtime switcher script
└── templates/
    ├── waybar.nix             # → ~/.config/themes/{dark,light}/waybar.css
    ├── qutebrowser.nix        # → ~/.config/themes/{dark,light}/qutebrowser.py
    ├── ghostty.nix            # → ~/.config/themes/{dark,light}/ghostty
    ├── wofi.nix               # → ~/.config/themes/{dark,light}/wofi.css
    ├── foot.nix               # → ~/.config/themes/{dark,light}/foot
    └── tmux.nix               # → ~/.config/themes/{dark,light}/tmux.conf
```

## How It Works

### Build time (Nix)

`default.nix` imports both palettes and all templates, then uses `xdg.configFile` to write both dark and light variants for every app into `~/.config/themes/`:

```
~/.config/themes/
├── dark/
│   ├── waybar.css
│   ├── qutebrowser.py
│   ├── ghostty
│   ├── wofi.css
│   ├── foot
│   └── tmux.conf
└── light/
    └── (same files)
```

Each template is a pure Nix function `scheme → string`. It receives the palette attrset and returns the config file content as a string using Nix string interpolation.

### Runtime (toggle-theme)

`toggle-theme` is a shell script exposed as a binary via `pkgs.writeShellScriptBin`. When run it:

1. Reads current mode from `~/.cache/style/mode` (defaults to `dark` if missing)
2. Toggles to the other mode
3. Updates symlinks in `~/.cache/style/` pointing to the new variant in `~/.config/themes/<mode>/`:
   - `waybar-colors.css` → `themes/<mode>/waybar.css`
   - `qutebrowser-theme.py` → `themes/<mode>/qutebrowser.py`
   - `ghostty-theme` → `themes/<mode>/ghostty`
   - `wofi.css` → `themes/<mode>/wofi.css`
   - `foot-theme` → `themes/<mode>/foot`
4. Writes new mode to `~/.cache/style/mode`
5. Live-reloads each app:
   - **ghostty** — `pkill --signal USR2 ghostty`
   - **waybar** — kill and restart (`pkill waybar && waybar &`)
   - **qutebrowser** — IPC via `qutebrowser ":config-source ;; set ..."`
   - **foot** — `pkill -HUP foot`
   - **tmux** — `tmux source-file ~/.config/themes/<mode>/tmux.conf`
   - **GTK** — `gsettings set org.gnome.desktop.interface gtk-theme / color-scheme`
6. Sends a desktop notification

Each app is configured to load its theme file from the symlink path, not directly from `~/.config/themes/`, so the symlink swap is all that's needed at runtime.

## Color Palette (Base16)

Both palettes follow the Base16 convention:

| Slot   | Role                         |
|--------|------------------------------|
| base00 | Background                   |
| base01 | Lighter background / status bars |
| base02 | Selection background / inactive borders |
| base03 | Comments / dimmed text       |
| base04 | Dark foreground              |
| base05 | Main text                    |
| base06 | Light foreground             |
| base07 | Light background             |
| base08 | Red — warnings/errors        |
| base09 | Orange                       |
| base0A | Yellow                       |
| base0B | Green                        |
| base0C | Cyan/Aqua                    |
| base0D | Blue — accent / active borders / focused workspace |
| base0E | Purple                       |
| base0F | Brown                        |

### Key colors to keep consistent across palettes

- `base00` — background
- `base02` — inactive borders
- `base05` — main text
- `base08` — warning/error color
- `base0D` — primary accent (focused borders, selected tabs, waybar accent)

## Template Notes

- **foot.nix** — strips the leading `#` from hex colors (`builtins.substring 1 6`) because foot's config format doesn't use the `#` prefix.
- **qutebrowser.nix** — detects dark vs light by checking if `scheme.slug` contains `"dark"` (using `builtins.match`), sets `preferred_color_scheme` accordingly.
- **tmux.nix** — in dark mode uses `bg=default` (transparent terminal background); in light mode uses `base01` as an explicit status bar background.
- **waybar.nix** — exposes both the raw Base16 variables and semantic aliases (`background`, `text`, `accent`, `urgent`, `hover`) so the waybar style.css can reference meaningful names instead of slot codes.
- **gtk.nix** — sets a static Adwaita base; runtime GTK switching happens via `gsettings` in `toggle-theme.sh`.

## Adding a New App

1. Create `templates/<app>.nix` — a function `scheme: ''...''` returning the config string.
2. Import it in `default.nix` and add two `xdg.configFile` entries (dark + light).
3. Add a `ln -sf` line in `toggle-theme.sh` for the symlink under `~/.cache/style/`.
4. Add the live-reload command for that app at the end of `toggle-theme.sh`.
5. Configure the app to load its theme from the `~/.cache/style/` symlink path.
