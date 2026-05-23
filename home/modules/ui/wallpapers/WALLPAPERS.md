# Wallpaper System

Random wallpaper rotation that picks from a pool matched to the current dark/light mode and screen resolution. A systemd timer fires every 5 minutes; the wallpaper script does the selection and hands the path to sway.

## Directory Layout

```
home/modules/ui/wallpapers/
├── default.nix               # Installs scripts + symlinks assets + declares systemd timer
└── scripts/
    ├── wallpaper.sh          # Picks a random wallpaper and applies it via swaymsg
    └── screen-resolution.sh  # Returns "wide", "ultrawide", or "normal" for the focused output

home/assets/wallpapers/       # Wallpaper image files (symlinked to ~/Pictures/Wallpapers)
├── wide/
│   ├── dark/                 # Classical paintings — Norwegian fjords, Russian seascapes, Kandinsky
│   └── light/                # Classical paintings + canaima landscape photos + mountains
└── ultrawide/
    ├── dark/                 # Abstract / artistic
    └── light/                # Abstract / artistic (lighter variants)
```

## How It Works

### Build time (Nix)

`default.nix` does three things:

1. Wraps `wallpaper.sh` and `screen-resolution.sh` as binaries via `pkgs.writeShellScriptBin` and adds them to `home.packages`.
2. Symlinks `home/assets/wallpapers/` → `~/Pictures/Wallpapers` (recursive, so individual files are tracked by Nix).
3. Declares a systemd user service + timer pair.

### Runtime

`screen-resolution.sh` queries the focused sway output via `swaymsg -t get_outputs | jq`, computes `width * 100 / height`, and returns:

| Ratio     | Result      |
|-----------|-------------|
| > 230     | `ultrawide` |
| 170–230   | `wide`      |
| < 170     | `normal`    |

`wallpaper.sh` then:

1. Reads `~/.cache/style/mode` (defaults to `dark`).
2. Calls `screen-resolution` to get the resolution tier.
3. Builds the path `~/Pictures/Wallpapers/<resolution>/<mode>/`.
4. Picks a random file with `find … | shuf -n 1`.
5. Applies it: `swaymsg "output * bg '<path>' fill"`.
6. Writes the selected path to `~/.cache/style/current_wallpaper`.

### Systemd timer

| Unit    | Key settings                                   |
|---------|------------------------------------------------|
| Service | `Type=oneshot`, runs after `graphical-session.target` |
| Timer   | `OnBootSec=10s`, `OnUnitActiveSec=5m`          |

The timer is `WantedBy=timers.target`, so it starts automatically on login.

## Integration with the Theme System

The wallpaper script reads `~/.cache/style/mode`, the same file written by `toggle-theme`. This means switching themes via `toggle-theme` will cause the next timer tick (≤5 min) to automatically pull a wallpaper from the matching dark/light pool. No explicit coupling is needed.

## Adding New Wallpapers

Drop the image into the appropriate subdirectory under `home/assets/wallpapers/`:

- Match the screen type to where it will look best (`wide` vs `ultrawide`).
- Pick `dark` for moody/high-contrast images, `light` for bright/airy ones.
- The file is picked up automatically on the next timer tick — no Nix rebuild needed after the initial `home-manager switch` that creates the symlink.

## Adding a "normal" Resolution Tier

`screen-resolution.sh` already outputs `normal` for aspect ratios below 170%, but `home/assets/wallpapers/normal/` does not exist yet. To add it:

1. Create `home/assets/wallpapers/normal/dark/` and `normal/light/` and populate them.
2. No script changes needed — `wallpaper.sh` builds the path dynamically.
