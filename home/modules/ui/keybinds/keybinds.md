# Keybindings

Shared keybinds across Sway and Hyprland, generated from a single source of truth in `default.nix`.

## Modifier key

`$mod` is set to `SUPER` (Sway: `Mod4`) in both WMs, but **Alt and Super are swapped at the
XKB level** via `altwin:swap_alt_win` — set in both `sway/configFiles/config` and
`hyprland.conf`.

This means:
- Physical **Alt key** → reported as Super → triggers all `$mod` binds
- Physical **Super/Win key** → reported as Alt → reaches terminal app meta shortcuts

Why: both tmux and qutebrowser use Alt/Meta for tab switching:
- Tmux: `M-{` / `M-}` (previous/next window) — `tmux.conf:44-45`
- Qutebrowser: `<Meta-Shift-{>` / `<Meta-Shift-}>` (prev/next tab) — `qutebrowser/default.nix:65-66`

Without the swap, `$mod = SUPER` and `Alt+Shift+{` would be a free combo — but the tab
switching binds use Alt, not Super. If `$mod` were Alt instead, Sway/Hyprland would intercept
`Alt+Shift+{` before tmux or qutebrowser ever see it. The swap avoids this: physical Alt
becomes the WM `$mod`, and physical Super/Win delivers Alt to applications unintercepted.

To remove the swap you'd need to rebind tab switching in both tmux and qutebrowser to a
combo that doesn't conflict with `$mod`.

## Structure

```
keybinds/
  default.nix   — vars attrset (all keybinds + app definitions)
  sway.nix      — generates sway/shared-keybinds.conf
  hyprland.nix  — generates hypr/shared-keybinds.conf
```

`default.nix` defines a `vars` attrset and passes it to both WM files via `(import ./sway.nix vars)`. Each WM file is a function `vars: { lib, ... }: { ... }` — a pure transformation of `vars` into config text.

## Adding a run-or-raise app

Only `default.nix` needs to change:

1. Add an attrset to `vars`:

```nix
myApp = {
  keybind = "$mod+x";
  app     = "my-app";
  appId   = "my-app-id";
};
```

2. Append it to `runOrRaiseApps` in the same file:

```nix
runOrRaiseApps = [ ... myApp ];
```

Both WM files read `runOrRaiseApps` from `vars` — no changes needed there.

### Optional fields

| Field          | Default    | Effect |
|----------------|------------|--------|
| `matchBy`      | `"app_id"` | Set to `"title"` to match by window title instead of app_id/class |
| `extraCriteria`| `""`       | Extra Sway criteria appended to the `[...]` block (e.g. `title="Gemini"`) |

## Run or Raise

| Key | App |
|-----|-----|
| `Super + Q` | Primary terminal (hostSpec) |
| `Super + Shift + Q` | Auxiliary terminal (hostSpec) |
| `Super + A` | AI / Gemini (hostSpec) |
| `Super + B` | Browser (hostSpec) |
| `Super + S` | Slack |
| `Super + F` | Firefox |
| `Super + G` | Google Chrome |
| `Super + Shift + F` | Factorio |

## Screenshots

| Key | Action |
|-----|--------|
| `Print` | Full screen → file |
| `Shift + Print` | Area → file |
| `Ctrl + Print` | Area → clipboard |

## Actions

| Key | Action |
|-----|--------|
| `Super + C` | Kill focused window |
| `Super + Shift + C` | Reload config |
| `Super + Shift + E` | Exit session |
| `Super + Ctrl + Q` | Lock screen |
| `Super + Shift + Ctrl + T` | Toggle theme |

## Menus

| Key | Menu |
|-----|------|
| `Super + D` | App launcher |
| `Super + M` | Bookmarks |
| `Super + P` | Projects |
| `Super + Shift + P` | Projects (CTwo) |

## Misc

| Key | Action |
|-----|--------|
| `Super + Shift + W` | Change wallpaper |
| `Super + Shift + /` | Show keybinds |
| `Super + Shift + I` | Network manager |
