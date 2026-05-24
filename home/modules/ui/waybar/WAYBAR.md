# Waybar

Status bar for Sway and Hyprland, configured via Home Manager.

## File Structure

```
home/modules/ui/waybar/
├── default.nix               # Top-level: enables waybar, assembles CSS, declares feature options
├── style.css                 # Global font and bar background
├── components/
│   ├── default.nix           # Imports all components, defines modules-right ordering
│   ├── components.css        # Right-side margin/padding
│   ├── workspaces/
│   │   ├── default.nix       # WM detection — selects hyprland or sway modules-left
│   │   ├── workspace-hyprland.nix
│   │   ├── workspace-sway.nix
│   │   └── workspaces.css
│   ├── clock/
│   ├── battery/
│   ├── network/
│   ├── pulseaudio/
│   ├── bluetooth/
│   ├── vpn/
│   ├── memory/               # Disabled — commented out in components/default.nix
│   └── cpu/                  # Disabled — commented out in components/default.nix
```

## How It Works

### CSS pipeline

`default.nix` concatenates all CSS files in order and feeds them to `programs.waybar.style`.
The first line is a runtime `@import` from `~/.cache/style/waybar-colors.css`, which the
theme system generates. All color variables (`@background`, `@text`, `@accent`, `@urgent`,
`@hover`, `@base00`–`@base0F`) come from there. See `home/modules/ui/themes/THEMES.md`.

### Feature flags

Two module-level options gate optional components. Set them in your home profile:

```nix
features.bluetooth = true;   # adds bluetooth module to modules-right and its CSS
features.vpn = true;         # adds custom/vpn module to modules-right and its CSS
```

### WM detection

`components/workspaces/default.nix` reads `config.wayland.windowManager.hyprland.enable`
to choose between `hyprland/workspaces` (+ `hyprland/submap`) and `sway/workspaces`
(+ `sway/mode`) for `modules-left`. The same flag is used in `network/default.nix` and
`pulseaudio/default.nix` to select which terminal to use for modal launchers.

**Critical:** this flag must match the WM actually running. If `wayland.windowManager.hyprland.enable`
is `true` but Sway is running (or vice versa), the workspace indicator will be blank — the
IPC socket for the other WM won't exist.

The Hyprland home module (`home/modules/ui/hyprland/default.nix`) sets `enable = true`.
The Sway home module (`home/modules/ui/sway/default.nix`) currently does NOT set
`wayland.windowManager.sway.enable = true` explicitly, so the detection relies on Hyprland
being the opt-in. If the Sway module ever starts setting `enable = true`, the workspaces
logic should be audited.

### Module layout

| Position       | Modules                                              |
| -------------- | ---------------------------------------------------- |
| `modules-left` | `sway/workspaces` + `sway/mode`  OR  `hyprland/workspaces` + `hyprland/submap` |
| `modules-center` | `clock`                                            |
| `modules-right`  | `[bluetooth]` `[custom/vpn]` `pulseaudio` `network` `battery` |

Bluetooth and VPN are bracketed because they are feature-flag gated.

## Workspace Icons

### Sway

| State    | Icon  |
| -------- | ----- |
| focused  | `""` |
| default  | `"󰄰"` |
| urgent   | `""` |

### Hyprland

| State   | Icon  |
| ------- | ----- |
| active  | `""` |
| default | `""` |
| empty   | `"󰄰"` |
| urgent  | `""` |

The focused/active workspace is colored `@accent` (blue in the current theme). Hover goes
to `@base0A` (yellow). See `workspaces/workspaces.css`.

## Known Issues

### Workspace indicator goes blank after a rebuild that gets WM detection wrong

**Root cause:** If the last `nixos-rebuild switch` ran with `wayland.windowManager.hyprland.enable = true`
in the profile (even temporarily), the generated waybar config will use `hyprland/workspaces`.
Running Sway after that leaves the workspace area empty because there is no Hyprland IPC socket.

**Symptom:** Workspace area is invisible; no workspace buttons appear in waybar.

**Fix:** Make sure the correct WM module is imported in the home profile, then rebuild:
```bash
sudo nixos-rebuild switch --flake .#canaima
```

**Prevention:** The Sway home module should have `wayland.windowManager.sway.enable = true`
explicitly set so the detection is symmetric and explicit on both sides.

### Terminal mismatch in network and pulseaudio

`network/default.nix` and `pulseaudio/default.nix` hard-code `kitty` for Hyprland and
`foot` for Sway via the same `isHyprland` flag. If the flag is wrong at build time, the
wrong terminal is baked into the on-click command. Not visible until you click the module.

---

## Future Improvements

### High priority

- **Explicit sway enable:** Add `wayland.windowManager.sway.enable = true;` to
  `home/modules/ui/sway/default.nix`. Right now the sway module never sets this, which
  makes the WM detection implicit and fragile. Hyprland sets `enable = true`; Sway should
  too. The workspaces logic already handles the `if hyprlandEnabled then … else …` pattern
  correctly once both sides are explicit.

- **Use `hostSpec.terminal` in waybar components:** `network/default.nix` and
  `pulseaudio/default.nix` re-implement terminal selection with `if isHyprland`. They
  should just read `config.hostSpec.terminal` (and `config.hostSpec.terminalAppId` for the
  `--app-id`/`--class` flag), since the profile already declares the correct terminal. This
  removes a second source of truth and fixes the mismatch automatically.

### Medium priority

- **`features.windowManager` option:** Add a `features.windowManager` option (values:
  `"sway"` or `"hyprland"`) to `waybar/default.nix`, similar to `features.bluetooth` and
  `features.vpn`. Use it instead of `config.wayland.windowManager.hyprland.enable` for all
  waybar decisions. This decouples waybar from the HM WM module state and makes intent
  explicit at the profile level.

- **Re-enable CPU and memory modules:** `components/default.nix` has both commented out.
  They already have CSS and nix definitions. A `features.sysinfo = false` flag (default off)
  would let you enable them per profile without editing shared files.

- **Persistent workspace count from hostSpec:** The number of persistent workspaces (4 for
  Hyprland, 5 for Sway) is hard-coded in each workspace nix file. A `hostSpec.workspaceCount`
  option would let profiles declare this once.

### Low priority

- **System tray:** No tray module is currently configured. Adding `"tray"` to `modules-right`
  (before the other modules) would let appindicator apps (1Password, network-manager-applet,
  etc.) show there.

- **Idle inhibitor module:** Useful for presentations. A `custom/idle-inhibitor` toggle for
  `swayidle`/`hypridle` would fit naturally next to the clock.

- **Per-monitor bar via `output`:** The bar currently has no `output` key, so it appears on
  all monitors. Adding an option to restrict it to a specific monitor (or spawn one per
  monitor with different content) would help multi-monitor setups.

- **Modules-right ordering option:** `modules-right` order is assembled in
  `components/default.nix` with `lib.optionals`. Making the order a profile-level list
  option would allow customization without editing shared files.
