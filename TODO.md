# TODO

## Bugs

---

## Solved Bugs

- **Sway dual-monitor / lid-close on Ubuntu (`playa-el-yaque`)** — Fixed 2026-05-26. Two symptoms:
  1. **Wrong active output:** `eDP-1` stayed active after lid close; new windows opened on the invisible laptop screen.
  2. **Workspace numbering gaps:** Workspaces interleaved across both outputs (1, 3, 5 on one; 2, 4, 6 on the other). After lid close only the external monitor's half remained reachable.
  - **Root cause:** `monitors.conf` used bare `swaymsg` in the `bindswitch` commands. Since Sway was moved to the Nix package (May 2026), `swaymsg` is no longer in the system PATH — same issue as the run-or-raise fix. The `bindswitch` silently failed so `eDP-1` was never disabled.
  - **Fix:** changed both `bindswitch` lines in `monitors.conf` to use `$swaymsg` (full nix-profile path set in `variables.conf`). Deploy with `home-manager switch --flake .#playa-el-yaque`.

---

## Improvements

Improvements collected from module docs and `changes.md`. Each item links to the relevant
module doc where more context lives.

---

### Cross-cutting

- **Rebuild `sarisarinama`** — verify `playa-caribe` profile is up to date after recent changes.
- **Test Hyprland on `playa-el-yaque`** — the Hyprland module was added but never booted; needs a first-login test.
- **Unify terminal declaration** — `$term` / `$term_id` come from `hostSpec`, but waybar components (`network`, `pulseaudio`) and several binds still hardcode `foot` / `kitty`. Use `config.hostSpec.terminal` everywhere.
- **Swayidle / power management** — no idle timeout, screen dim, or suspend-on-lid is configured. Add a `swayidle` home module. See also sway.md → Future Improvements.
- **Kanshi** — imported in `playa-el-agua` with a "do I really use this?" comment. Audit and either configure properly or remove.

---

### Sway ([sway.md](home/modules/ui/sway/sway.md))

- **Inject app variables from `hostSpec`** — `$browser`, `$ai`, `$slack`, `$chrome`, and their `_id` counterparts are hardcoded in `variables.conf`. Make them `hostSpec` options so profiles can override without editing shared files.
- **Split `bindings.conf` by category** — the file mixes navigation, layout, scratchpad, and resize mode. Split into fragments for easier auditing.
- **Screen scale via `hostSpec`** — `config` hard-codes `output eDP-1 scale 1.2`. A `hostSpec.displayScale` option would let each profile set correct DPI without touching shared config.
- **Waybar restart reliability** — `autostart.conf` uses `pkill waybar; waybar`. Replace with `systemctl --user restart waybar` to avoid a race on startup.
- **Firefox PWA bind** — `$ai` bakes in a hardcoded PWA ID (`01KS5C2YJE85WR6YP8K4Q584CZ`). Make it a `hostSpec` option or a profile-level override.

---

### Waybar ([waybar.md](home/modules/ui/waybar/waybar.md))

- **Use `hostSpec.terminal` in waybar components** — `network/default.nix` and `pulseaudio/default.nix` still branch on `isHyprland` to pick the terminal. Read `config.hostSpec.terminal` and `config.hostSpec.terminalAppId` directly.
- **Re-enable CPU and memory modules** — both are commented out in `components/default.nix` with CSS and nix definitions ready. Add a `hostSpec.sysinfo` flag (default off) to enable per profile.
- **Persistent workspace count from `hostSpec`** — number of persistent workspaces (4 for Hyprland, 5 for Sway) is hard-coded per WM file. A `hostSpec.workspaceCount` option would centralise this.

---

### Tmux ([tmux.md](home/modules/terminals/tmux/tmux.md))

- **Wayland clipboard integration** — `y` in copy mode uses tmux's internal clipboard. Wire it to `wl-copy` so yanked text lands in the system clipboard.
- **Prefix key** — no custom prefix; defaults to `Ctrl+b`. Consider binding to `Ctrl+Space` or `Ctrl+a`.
- **Nix-managed plugins** — declare plugins (`tmux-resurrect`, `tmux-continuum`) in `default.nix` via `programs.tmux.plugins` instead of TPM.
- **Per-profile shell** — shell is hardcoded to `bash`. Derive it from `hostSpec` or `programs.zsh.enable`.

---

### Menus ([menus.md](home/modules/menus/menus.md))

- **Unify `playa-el-yaque` menu value** — change `hostSpec.menu` to `"wofi --dmenu"` and let each script handle its own `--conf` path. Current embedded-flags value is fragile.
- **Theme-aware bemenu** — `bemenu/default.nix` uses hardcoded hex colors. Read from `~/.cache/style/` like the theme system does; add a `themes/templates/bemenu.nix`.
- **Retire static `wofi/style.css`** — once `wofi.nix` generates the full style, delete the static file to remove ambiguity about the source of truth.
- **Walker migration** — evaluate [Walker](https://walkerlauncher.com/) as a wofi replacement on `playa-el-yaque` (faster, fuzzy search, better theming).
- **Single wofi conf file** — four separate `.conf` files differ only in `width`, `height`, and `hide_search`. Consolidate into one with per-call CLI overrides.
- **Consistent key navigation** — wofi has vim-style nav; bemenu does not. Expose bemenu key bindings via `home.sessionVariables`.

---

### Scripts ([scripts.md](home/modules/scripts/scripts.md))

- **`projects` — session restore** — detect an existing tmux session whose working directory matches the project and reattach instead of always creating a new one.
- **`projects` — devenv auto-start** — when a project has `devenv.nix`, optionally run `devenv up` in a `services` window on first session creation.
- **`bookmarks` — edit bookmark files** — add a "New bookmark" option that opens the chosen `.txt` file in `$EDITOR` from within the menu flow.
- **`system-menu` — Do-Not-Disturb toggle** — add a quick DND toggle (`makoctl set-mode dnd`) alongside Sound.
- **`power-menu` — suspend** — add a `Suspend` option (`systemctl suspend`).
- **`keybinds` — Neovim sync** — Neovim keybinds are hardcoded; they could be read from `config.neovim.keybinds.*` options if those are declared in the neovim module.

---

### Gazelle ([gazelle.md](home/modules/tui/gazelle/gazelle.md))

- **Add to `playa-el-agua`** — Gazelle is only imported in `playa-el-yaque`. Add it to the NixOS profile.
- **Expose launch path via `hostSpec`** — the binary path is hardcoded as `~/.nix-profile/bin/gazelle` in the sway binding and waybar component.
- **Run-or-raise for Gazelle** — `Mod+Shift+i` always opens a new instance. Apply the standard run-or-raise pattern (`swaymsg '[app_id="network"] focus' || exec ...`).

---

### Quickshell ([quickshell/TODO.md](home/modules/quickshell/TODO.md))

- **Add wifi widget.**
- **Investigate Tray support** — does it work at all?
- **Battery icon tooltip** — show percentage and estimated time remaining on hover.
- **Wifi icon tooltip** — show current network name on hover.
