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
`@hover`, `@base00`–`@base0F`) come from there. See [themes.md](../themes/themes.md).

### hostSpec flags

All machine-level flags live in `hostSpec` (see `home/modules/core/hostSpec/default.nix`).
Set them in your profile's `hostSpec { }` block:

```nix
hostSpec = {
  windowManager = "sway";   # or "hyprland" — controls workspace IPC and terminal flags
  bluetooth = true;         # adds bluetooth module to modules-right and its CSS
  vpn = true;               # adds custom/vpn module to modules-right and its CSS
};
```

`windowManager` defaults to `"sway"`, `bluetooth` and `vpn` default to `false`.

### WM detection

`components/workspaces/default.nix` reads `config.hostSpec.windowManager` to choose
between `hyprland/workspaces` (+ `hyprland/submap`) and `sway/workspaces` (+ `sway/mode`)
for `modules-left`. The same flag is used in `network/default.nix` and `pulseaudio/default.nix`
to select which terminal to use for modal launchers.

This decouples waybar from `wayland.windowManager.*.enable` state. A profile can import
both WM modules (e.g. `playa-el-yaque` imports both sway and hyprland) without waybar
picking the wrong one.

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

### ~~Workspace indicator goes blank~~ (fixed)

Previously, waybar read `wayland.windowManager.hyprland.enable` to decide between
`hyprland/workspaces` and `sway/workspaces`. On profiles that import both WM modules
(like `playa-el-yaque`), Hyprland's `enable = true` always won, leaving the workspace
area blank when Sway was running.

**Fixed:** waybar now reads `features.windowManager` (an explicit profile-level option)
instead of the HM WM module state. Set `features.windowManager = "sway"` or
`features.windowManager = "hyprland"` in your profile.

### Terminal mismatch in network and pulseaudio

`network/default.nix` and `pulseaudio/default.nix` hard-code `kitty` for Hyprland and
`foot` for Sway via the same `isHyprland` flag. If the flag is wrong at build time, the
wrong terminal is baked into the on-click command. Not visible until you click the module.

---

## Future Improvements

### High priority

- **Use `hostSpec.terminal` in waybar components:** `network/default.nix` and
  `pulseaudio/default.nix` still use `if isHyprland` to pick the terminal binary and flag.
  They should read `config.hostSpec.terminal` and `config.hostSpec.terminalAppId` directly,
  since the profile already declares the correct terminal. This removes the last
  WM-conditional in those files.

### Medium priority

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
