# Scripts

Interactive launcher scripts exposed as Nix-wrapped binaries. Each script accepts a menu command (e.g. `wofi --dmenu`) as its first argument(s), making them menu-agnostic — the concrete command is baked in at build time by the `default.nix` wrapper using `hostSpec.menu`.

## Directory Layout

```
home/modules/scripts/
├── bookmarks/
│   ├── default.nix       # Wraps bookmarks.sh; sources hm-session-vars; injects hostSpec.menu
│   └── bookmarks.sh      # Two-level menu: category → bookmark → open in browser
├── keybinds/
│   └── default.nix       # Generates content at eval time from config.keybinds.*; no shell script
├── projects/
│   ├── default.nix       # Creates "projects" (~/dev) and "projects-ctwo" (~/nix/ctwo/repository)
│   └── projects.sh       # Recursive dir browser → tmux session with standard windows
├── power-menu/
│   ├── default.nix       # Wraps power-menu.sh; injects hostSpec.menu
│   └── power-menu.sh     # Shutdown / Reboot / Lock / Logout
├── system-menu/
│   ├── default.nix       # Wraps system-menu.sh; injects hostSpec.menu
│   └── system-menu.sh    # Top-level meta-menu that delegates to sub-actions
└── default.nix           # Imports all five sub-modules

# Related scripts elsewhere:
home/modules/ui/wallpapers/scripts/
├── wallpaper.sh          # Picks a random wallpaper matching mode + resolution, applies via swaymsg
└── screen-resolution.sh  # Returns "wide", "ultrawide", or "normal" for the focused output

home/modules/ui/themes/scripts/
└── toggle-theme.sh       # Switches dark/light mode; updates symlinks; live-reloads all apps

home/modules/menus/wofi/scripts/
└── keybinds.sh           # Shows a keybindings HUD inside a terminal (WM-aware)
    (others are legacy wofi-only versions superseded by home/modules/scripts/)
```

## Scripts Reference

### `bookmarks`

Two-level wofi menu that opens URLs from category files.

- Reads `~/.config/bookmarks/*.txt` (populated by Nix from `home/assets/bookmarks/`)
- First menu: pick a category (filename without extension, title-cased)
- Second menu: pick a bookmark (`label  url` format; `#` lines are comments)
- Opens in **qutebrowser** for all categories except `work.txt`, which uses **brave**
- Handles focus: tries to focus an existing browser window before opening a new one (Sway + Hyprland aware)

**Sway keybind:** `Super + m`

### `projects`

Recursive directory browser that creates standardised tmux sessions.

- Walks `~/dev` (or `~/nix/ctwo/repository` for `projects-ctwo`), one level at a time
- Stops drilling when it finds a `.git` directory or `devenv.nix`
- Session name: relative path from the root with `/` and `.` replaced by `_`
- On new session, creates four windows: `claudio` (claude), `editor` (nvim-web), `console` (bash), `lazygit`
- Loads `.tmux-init.conf` from the project root if present (for custom window layouts)
- Switches an existing tmux client if already attached; otherwise opens a new terminal

**Sway keybinds:**
- `Super + p` → `projects` (~/dev)
- `Super + Shift + p` → `projects-ctwo` (~/nix/ctwo/repository)

### `power-menu`

Single-level menu for system power actions.

Options: Shutdown (`systemctl poweroff`), Reboot (`systemctl reboot`), Lock (swaylock / hyprlock), Logout (`loginctl terminate-user`).

Called directly or via `system-menu` → Power.

**No direct sway keybind** — reached through `system-menu` (`Super + d` → Power).

### `system-menu`

Top-level meta-menu that delegates to sub-actions.

| Option       | Action                                                                 |
|--------------|------------------------------------------------------------------------|
| Applications | `wofi --show drun` (or `<menu>-run` fallback)                          |
| Keybinds     | Opens `keybinds` in a floating `foot`/`kitty` terminal                 |
| Bluetooth    | Opens `bluetuith` in a floating terminal (shown only if BT hardware present) |
| Sound        | Opens `pulsemixer` in a floating terminal                              |
| Network      | Opens `gazelle` in a floating terminal                                 |
| Power        | Delegates to `power-menu`                                              |

**Sway keybind:** `Super + d`

### `wallpaper`

Picks a random wallpaper from `~/Pictures/Wallpapers/<resolution>/<mode>/` and applies it via `swaymsg output * bg … fill`. Writes the selected path to `~/.cache/style/current_wallpaper`. See [wallpapers.md](../ui/wallpapers/wallpapers.md) for the full picture.

**Sway keybind:** `Super + Shift + w`  
Also runs automatically on startup and via a systemd timer every 5 minutes.

### `toggle-theme`

Toggles dark/light mode. Reads `~/.cache/style/mode`, swaps symlinks under `~/.cache/style/`, and live-reloads all themed apps. See [themes.md](../ui/themes/themes.md).

**Sway keybind:** `Super + Shift + Ctrl + t`

### `keybinds`

Two-level interactive cheat-sheet displayed in a floating `foot -a keybinds` terminal. All content is generated at Nix eval time — no runtime parsing. Waits for a keypress, then exits.

**Menu structure:**

```
Keybinds
├── System
│   ├── Applications   (run-or-raise apps from config.keybinds.runOrRaiseApps)
│   ├── Screenshots    (screenshot + wallpaper binds)
│   └── Actions        (WM actions: kill, launcher, lock, theme, …)
└── Neovim
    ├── General        (oil, neo-tree, splits, folds, fzf, buffers)
    ├── Surround       (nvim-surround operators + examples)
    ├── LSP
    │   ├── Common     (gd, gr, K, rename, code actions, …)
    │   ├── Java       (jdtls: scaffolding, refactor, codegen, test, maven)
    │   ├── Rust       (cargo build/run/test/clean)
    │   ├── C#         (no custom binds — refers to Common)
    │   └── Web        (vtsls: organize/sort/remove/add imports)
    └── Debugger       (nvim-dap: continue, step, breakpoints, UI, REPL)
```

System keybinds are read from `config.keybinds.*` (declared in `home/modules/ui/keybinds/default.nix`). Neovim keybinds are hardcoded in `home/modules/scripts/keybinds/default.nix`. Window dimensions are computed at eval time from the line count of each section.

**Keybind:** `Super + Shift + Y`

### Screenshot bindings (inline, no script)

Defined in `home/modules/ui/sway/special-binds/screenshot-binds.conf`. Uses `$grim` and `$slurp` sway variables.

| Keybind           | Action                                        |
|-------------------|-----------------------------------------------|
| `Print`           | Full screenshot → `~/Pictures/screenshots/`   |
| `Shift + Print`   | Area screenshot → `~/Pictures/screenshots/`   |
| `Ctrl + Print`    | Area screenshot → clipboard (`wl-copy`)       |

### Lock screen (inline, no script)

`Super + Ctrl + q` → `swaylock --image $(cat ~/.cache/style/current_wallpaper)` — uses the last wallpaper selected by the `wallpaper` script.

## How Nix Wiring Works

Each `default.nix` follows the same pattern:

1. Read the shell script with `builtins.readFile` into a `*-base` binary.
2. Create a wrapper binary that sources `hm-session-vars.sh` (for correct PATH on both NixOS and Ubuntu), sets `BEMENU_BACKEND=wayland`, then `exec`s the base binary with `hostSpec.menu` hard-coded as arguments.
3. Add the wrapper (not the base) to `home.packages`.

This means the scripts never hard-code `wofi` — the menu program is determined once at `home-manager switch` time from `hostSpec.menu`.

## Future Improvements

- **`projects` — session restore**: detect an existing tmux session whose working directory matches the project and reattach, rather than always creating a new one when the name drifts (e.g. after a rename).
- **`projects` — devenv auto-start**: when a project has `devenv.nix`, optionally run `devenv up` in a dedicated `services` window when the session is first created.
- **`bookmarks` — edit bookmark files**: add a "New bookmark" option that opens the chosen `.txt` file in `$EDITOR` directly from within the menu flow.
- **`system-menu` — notifications toggle**: add a quick Do-Not-Disturb toggle (mako `makoctl set-mode dnd`) to the system menu alongside Sound.
- **`power-menu` — suspend**: add a `Suspend` option (`systemctl suspend`) for laptop lid-close-less suspend.
- **`keybinds` — Neovim sync**: Neovim keybinds are currently hardcoded; they could be read from `config.neovim.keybinds.*` options if those are ever declared in the neovim module.
