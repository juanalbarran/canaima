# Sway

Home Manager module for the Sway tiling window manager. Used on `canaima` (NixOS) via the
`playa-el-agua` home profile, and on `playa-el-yaque` (Ubuntu standalone HM). The NixOS-level
enablement lives in `nixos/modules/ui/sway/default.nix`; this module handles only the user
configuration layer.

## File Structure

```
home/modules/ui/sway/
├── default.nix                     # HM sway module entry; installs packages
└── configFiles/
    ├── default.nix                 # Deploys all config files via xdg.configFile
    ├── config                      # Main sway entry point; includes all fragments
    ├── variables.conf              # Nix-generated: variables + all run-or-raise bindsyms
    ├── autostart.conf              # Portal setup, wallpaper, waybar launch
    ├── bindings.conf               # Core keybindings (navigation, layout, workspaces)
    ├── monitors.conf               # Lid-switch output enable/disable
    └── rules.conf                  # Floating window rules for modal TUIs
```

## How Config Management Works

HM's sway module is used with `config = null`. This means HM does **not** generate the
sway config from Nix options. Instead, all config files are deployed as plain files via
`xdg.configFile` entries in `configFiles/default.nix`.

`variables.conf` is the only file generated with `.text` (Nix interpolation). It contains
both the `set $variable` definitions and all run-or-raise `bindsym` commands. All other
files are static `.conf` sources symlinked to the nix store.

The main `config` file uses `include` directives to compose the fragments:
```
~/.config/sway/variables.conf    ← Nix-generated: variables + run-or-raise bindsyms
~/.config/sway/autostart.conf
~/.config/sway/monitors.conf
~/.config/sway/rules.conf
~/.config/sway/bindings.conf     ← static: navigation, layout, workspaces, menus
/etc/sway/config.d/*             ← NixOS system-level additions
```

## variables.conf — Injected Variables and Run-or-Raise Bindings

Generated at build time from `configFiles/default.nix`. Contains two things:
1. `set $variable` definitions read by all other config files
2. Run-or-raise `bindsym` commands for every app (inlined after each app's variables)

### Variable ordering rule

All `$X_id` variables are defined **before** their `$X` counterpart. Sway's variable
substitution is a simple linear scan — if `$term` were defined first, it would match
the `$` in `$term_id` and corrupt the criteria. Defining `$term_id` first prevents this.

### Variables

| Variable          | Source                   | Example                        |
| ----------------- | ------------------------ | ------------------------------ |
| `$mod`            | hardcoded                | `Mod4` (Super key)             |
| `$swaymsg`        | path-prefixed            | `swaymsg`                      |
| `$term_id`        | `hostSpec.terminalAppId` | `foot`                         |
| `$term`           | `hostSpec.terminal`      | `foot`                         |
| `$aux_term_id`    | hardcoded                | `com.mitchellh.ghostty`        |
| `$aux_term`       | hardcoded                | `ghostty`                      |
| `$browser_id`     | hardcoded                | `org.qutebrowser.qutebrowser`  |
| `$browser`        | hardcoded                | `qutebrowser --target window`  |
| `$ai_id`          | hardcoded                | `FFPWA-01KS5C2YJE85WR6YP8K4Q584CZ` |
| `$ai`             | hardcoded                | `firefoxpwa site launch <id>`  |
| `$slack_id`       | hardcoded                | `Slack`                        |
| `$slack`          | hardcoded                | `slack`                        |
| `$chrome_id`      | hardcoded                | `google-chrome`                |
| `$chrome`         | hardcoded                | `google-chrome-stable`         |
| `$firefox_id`     | hardcoded                | `firefox`                      |
| `$firefox`        | hardcoded                | `firefox`                      |
| `$menu`           | path-prefixed            | `system-menu`                  |
| `$grim`           | path-prefixed            | `grim`                         |
| `$slurp`          | path-prefixed            | `slurp`                        |
| `$wallpaper`      | path-prefixed            | `wallpaper` script             |
| `$toggleTheme`    | path-prefixed            | `toggle-theme` script          |
| `$projects`       | path-prefixed            | `projects` script              |
| `$bookmarks`      | path-prefixed            | `bookmarks` script             |

`$swaymsg` has a path prefix because sway's `exec` environment inherits only the system
PATH (no nix profile). Path prefix is empty on NixOS and `$HOME/.nix-profile/bin/` on
standalone HM (Ubuntu).

## Core Keybindings

`Mod` = Super (Logo key). Direction keys follow vim: `h/j/k/l`.

| Binding                    | Action                                            |
| -------------------------- | ------------------------------------------------- |
| `Mod+q`                    | Focus terminal or launch `$term`                  |
| `Mod+Shift+q`              | Focus/launch `ghostty` (aux terminal)             |
| `Mod+c`                    | Kill focused window                               |
| `Mod+d`                    | System menu (`bemenu` launcher)                   |
| `Mod+b`                    | Focus/launch qutebrowser                          |
| `Mod+f`                    | Focus/launch Firefox PWA                          |
| `Mod+a`                    | Focus/launch Gemini AI (Firefox PWA)              |
| `Mod+s`                    | Focus/launch Slack                                |
| `Mod+g`                    | Focus/launch Google Chrome                        |
| `Mod+m`                    | Bookmarks menu                                    |
| `Mod+p`                    | Projects menu (personal)                          |
| `Mod+Shift+p`              | Projects menu (work / ctwo)                       |
| `Mod+Shift+w`              | Cycle wallpaper                                   |
| `Mod+Shift+i`              | Network manager TUI (foot, floating)              |
| `Mod+Shift+/`              | Keybinds help                                     |
| `Mod+Ctrl+Shift+t`         | Toggle dark/light theme                           |
| `Mod+Ctrl+q`               | Lock screen (swaylock with current wallpaper)     |
| `Mod+r`                    | Enter resize mode                                 |
| `Mod+Shift+Space`          | Toggle floating                                   |
| `Mod+Space`                | Toggle focus tiling/floating                      |
| `Mod+Shift+minus`          | Send to scratchpad                                |
| `Mod+-`                    | Show next scratchpad window                       |
| `Mod+Shift+c`              | Reload sway config                                |
| `Mod+Shift+e`              | Exit sway (with confirm prompt)                   |
| `Mod+1`–`Mod+0`            | Switch to workspace 1–10                          |
| `Mod+Shift+1`–`Mod+Shift+0`| Move container to workspace 1–10                  |
| `Print`                    | Screenshot fullscreen → `~/Pictures/screenshots/` |
| `Shift+Print`              | Screenshot region (slurp) → file                  |
| `Ctrl+Print`               | Screenshot region → clipboard                     |
| `XF86MonBrightnessUp/Down` | Brightness ±10 (via `light`)                      |
| `XF86AudioRaiseVolume`     | Volume +5%                                        |
| `XF86AudioLowerVolume`     | Volume -5%                                        |
| `XF86AudioMute`            | Toggle mute                                       |

### App-focus pattern

All app bindings live in `variables.conf`, right after the app's `set` lines:
```
set $browser_id org.qutebrowser.qutebrowser
set $browser env QT_QUICK_BACKEND=software qutebrowser --target window
bindsym $mod+b exec $swaymsg '[app_id="$browser_id"] focus' || exec $browser
```

`$swaymsg` must be used instead of bare `swaymsg` — sway's exec environment has only
the system PATH and cannot find binaries in the nix profile.

## Window Rules (`rules.conf`)

Certain apps always open as centred floating windows:

| `app_id`        | Size      | Notes                      |
| --------------- | --------- | -------------------------- |
| `network`       | 1000×800  | Gazelle TUI, border 3px    |
| `keybinds`      | 760×700   | Keybinds help TUI          |
| `pulsemixer`    | 800×500   | Audio mixer TUI            |
| `bluetooth-tui` | 800×500   | Bluetooth manager TUI      |

## Autostart (`autostart.conf`)

1. Kill existing XDG portals, re-import env vars into systemd and dbus (`DISPLAY`,
   `WAYLAND_DISPLAY`, `SWAYSOCK`, `XDG_CURRENT_DESKTOP`), restart portals. This fixes
   wallpaper script and screen sharing.
2. Force focus to workspace 1 on boot (fixes closed-lid startup bug where focus lands on
   a hidden workspace).
3. Run `$wallpaper` script (`exec_always` so it re-runs on config reload).
4. Kill and restart waybar (`exec_always`).

## Packages Installed

`grim`, `slurp`, `wtype`, `wev` — all added to `home.packages` in `default.nix`. The
screenshots dir `~/Pictures/screenshots/` is created via HM activation if missing.

## Known Issues

### ~~`wayland.windowManager.sway.enable` is not set~~ (fixed)

`enable = true` and `package = pkgs.sway` are now set unconditionally. Sway is installed
via Nix on both NixOS and standalone HM (Ubuntu). A `.desktop` session file is generated
at `~/.local/share/wayland-sessions/sway.desktop` on non-NixOS so the display manager can
find the Nix sway binary. Mirrors the Hyprland module pattern exactly.

### Non-NixOS: real file required in `/usr/share/wayland-sessions/` for GDM

GDM reads sessions from `/usr/share/wayland-sessions/` and runs as the `gdm` user. The HM
module places `sway.desktop` in `~/.local/share/wayland-sessions/` via `xdg.dataFile`.
`~/.local/share/` has `drwx------` (700) permissions, so the `gdm` user cannot traverse it —
a symlink through that directory is silently unresolvable and GDM skips the session.

After the first `home-manager switch` on a non-NixOS machine, create real files (not symlinks):

```bash
sudo tee /usr/share/wayland-sessions/sway.desktop << 'EOF'
[Desktop Entry]
Name=Sway
Comment=An i3-compatible Wayland compositor
Exec=/home/juan-albarran/.nix-profile/bin/sway
Type=Application
EOF

sudo tee /usr/share/wayland-sessions/hyprland.desktop << 'EOF'
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=/home/juan-albarran/.nix-profile/bin/hyprland
Type=Application
EOF
```

These files are owned by root, not managed by HM, and survive future `home-manager switch`
runs. The `Exec` path (`~/.nix-profile/bin/…`) is stable across rebuilds so the files never
need updating unless the username changes.

### Most app variables are hardcoded in `variables.conf`

Only `$term`, `$term_id`, `$swaymsg`, and `$menu` are path-injected from `hostSpec` or the
`isNixOS` flag. Browser, AI, Slack, Chrome, and Firefox variables are hardcoded strings,
so they are the same regardless of profile. If a profile needs a different app, edit
`configFiles/default.nix` directly.

---

## Future Improvements

### High priority

- **Inject more variables from `hostSpec`:** `$browser`, `$ai`, `$slack`, `$chrome`, and
  their `_id` counterparts are hardcoded in `variables.conf`. Making them `hostSpec` options
  (or at least profile-overridable) would let `playa-el-yaque` use different apps without
  editing shared files.

### Medium priority

- **Split `bindings.conf` by category:** The file mixes navigation, layout, scratchpad,
  and resize mode bindings. Splitting into separate fragments would make it easier to
  audit or disable categories per profile.

- **Screen scale via `hostSpec`:** `config` hard-codes `output eDP-1 scale 1.2`. A
  `hostSpec.displayScale` option would let each profile set the correct DPI scaling without
  touching the shared config file.

- **Idle and sleep integration:** There is no `swayidle` configuration in the module.
  Adding a `swayidle` rule (dim → lock → suspend) and wiring it to the lid-switch
  behaviour in `monitors.conf` would make power management complete.

- **Waybar restart on reload is fragile:** `autostart.conf` kills and relaunches waybar
  with `pkill waybar; waybar`. If the kill races with startup, waybar may fail to start.
  A `systemctl --user restart waybar` (after enabling the waybar systemd service) would be
  more reliable.

### Low priority

- **Firefox PWA bind uses a hardcoded PWA ID:** `$ai` is `firefoxpwa site launch 01KS5C2YJE85WR6YP8K4Q584CZ`.
  The ID should come from `hostSpec` or a dedicated option so it can vary per profile
  (work vs personal).

- **`$aux_term` and `$aux_term_id` are hardcoded to ghostty:** Same situation as `$term`.
  These should come from `hostSpec` or be optional (`mkIf`).

- **Commented-out bindings cleanup:** Several layout bindings (`$mod+g splith`, `$mod+v splitv`,
  `$mod+s layout stacking`, etc.) are commented out in `bindings.conf`. Either activate
  them or remove them to reduce noise.

- **Monitor config for external displays:** `monitors.conf` only handles the laptop lid
  switch for `eDP-1`. Adding `output` rules for common external monitors (resolution,
  position, scale) would avoid having to reconfigure manually after plugging in.
