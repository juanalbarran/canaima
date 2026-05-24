# Tmux

Home Manager module for tmux. Configured via HM's `programs.tmux` option with a static
`tmux.conf` for settings that don't need Nix interpolation.

## File Structure

```
home/modules/terminals/tmux/
├── default.nix   # Enables programs.tmux; sets terminal and shell; sources tmux.conf
└── tmux.conf     # Static config: colours, status bar, keybinds
```

## Configuration

| Setting              | Value                  | Notes                                      |
| -------------------- | ---------------------- | ------------------------------------------ |
| `terminal`           | `tmux-256color`        | Enables 256-colour and true-colour support |
| `shell`              | `bash`                 | Explicit bash path from pkgs               |
| `base-index`         | 1                      | Windows and panes numbered from 1          |
| `renumber-windows`   | on                     | Gaps closed automatically after closing    |
| `mode-keys`          | vi                     | Copy mode uses vi bindings                 |
| `set-clipboard`      | on                     | Passes clipboard ops to the outer terminal |
| `status-position`    | top                    | Status bar at the top                      |
| `status-justify`     | absolute-centre        | Window list centred in the status bar      |

True-colour is enabled via `terminal-overrides` (`xterm*:Tc`) to fix washed-out colours
in Starship and Ghostty.

## Status Bar

Minimal — only the session name on the left and window list centred. Date, time, and
hostname are hidden. Background is transparent (`bg=default`) so the terminal background
shows through.

| Element               | Colour              |
| --------------------- | ------------------- |
| Inactive window       | `base04` (dim)      |
| Active window         | `base0D` (blue)     |
| Status bar fg         | `base05` (fg)       |

Colours are overridden at runtime by the theme system (see below).

## Keybindings

| Binding      | Action                  |
| ------------ | ----------------------- |
| `M-{`        | Previous window         |
| `M-}`        | Next window             |
| `v` (copy)   | Begin selection (vi)    |
| `y` (copy)   | Copy selection and exit |

`M-{` / `M-}` are bound without a prefix so they work the same as Ghostty's native
window-switch shortcuts — Ghostty forwards them to tmux transparently.

## Theme Integration

The theme system generates `~/.config/themes/{dark,light}/tmux.conf` with base16 colour
values. When `toggle-theme` runs, it sources the correct file into the running tmux
session:

```bash
tmux source-file "$theme_dir/$new_mode/tmux.conf"
tmux refresh-client
```

This updates status-bar and pane-border colours without restarting tmux.

---

## Future Improvements

- **Wayland clipboard integration:** `y` in copy mode uses tmux's internal clipboard.
  The commented-out block in `tmux.conf` would pipe to `wl-copy` on Wayland or `xclip`
  on X11. Worth enabling so yanked text lands in the system clipboard.

- **Prefix key:** No custom prefix is set — tmux defaults to `Ctrl+b`. Binding it to
  `Ctrl+Space` or `Ctrl+a` would be more ergonomic for daily use.

- **Nix-managed plugins:** Plugins (e.g. `tmux-resurrect`, `tmux-continuum` for session
  persistence) could be declared in `default.nix` via `programs.tmux.plugins` instead of
  using TPM, keeping them in the Nix store.

- **Mouse support:** `set -g mouse on` would allow click-to-focus panes and scroll with
  the trackpad — useful when pairing or doing ad-hoc navigation.

- **Per-profile shell:** The shell is hardcoded to `bash`. Reading it from `hostSpec` (or
  deriving it from `programs.zsh.enable`) would make it consistent with the user's login
  shell.
