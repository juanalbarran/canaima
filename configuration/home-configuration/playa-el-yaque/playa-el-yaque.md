# playa-el-yaque

Work Ubuntu laptop home profile (standalone Home Manager). Named after Playa El Yaque, Margarita Island.
Not a NixOS host — standalone HM on Ubuntu.

## hostSpec

| Option          | Value                                                          |
| --------------- | -------------------------------------------------------------- |
| `username`      | `juan-albarran`                                               |
| `hostname`      | `playa-el-yaque`                                               |
| `email`         | work (`juan.albarran-ext@ctwo.com`)                            |
| `terminal`      | `foot`                                                         |
| `terminalAppId` | `foot`                                                         |
| `menu`          | `wofi --conf $HOME/.config/wofi/projects-menu.conf --prompt 'Projects:'` |
| `sshKeyName`    | `playa-el-yaque`                                               |
| `isNixOS`       | `false`                                                        |

## Features

| Option                    | Value   |
| ------------------------- | ------- |
| `features.windowManager`  | `sway`  |
| `features.vpn`            | `true`  |
| `features.bluetooth`      | `false` |

## Modules imported

| Module                          | Purpose                                      |
| ------------------------------- | -------------------------------------------- |
| `home/modules/core`             | gc, ssh, sops, hostSpec, packages            |
| `home/modules/ui/sway`          | Sway HM config (active WM)                  |
| `home/modules/ui/hyprland`      | Hyprland (installed, not active by default)  |
| `home/modules/ui/waybar`        | Status bar                                   |
| `home/modules/ui/wallpapers`    | Wallpaper management                         |
| `home/modules/ui/themes`        | Theme system (dark/light toggle)             |
| `home/modules/browsers`         | All browsers                                 |
| `home/modules/terminals`        | All terminals                                |
| `home/modules/scripts`          | Personal scripts                             |
| `home/modules/menus/wofi`       | wofi launcher                                |
| `home/modules/menus/bemenu`     | bemenu launcher                              |
| `home/modules/ai`               | Opencode AI                                  |
| `home/modules/openvpn`          | OpenVPN (work VPN)                           |
| `home/modules/tui/gazelle`      | Gazelle network TUI                          |
| `home/modules/work`             | Work-specific config (depends on secrets)    |
| `home/users/nix`                | HM user settings for non-NixOS              |

## XDG portals

```nix
sway     → xdg-desktop-portal-gtk
hyprland → xdg-desktop-portal-hyprland + xdg-desktop-portal-gtk
```
`xdg-desktop-portal-wlr` is also installed.

## Switching between WMs

Both Sway and Hyprland are installed and have `.desktop` session files in
`/usr/share/wayland-sessions/` (placed manually — GDM cannot traverse
`~/.local/share/` due to `700` permissions). To switch active WM in waybar:
change `features.windowManager` in this file and run `home-manager switch`.

## Notes

- `targets.genericLinux.enable = true` — required for standalone HM on non-NixOS.
- Depends on the private `fortin-de-la-galera` secrets repo (via sops and `work` module).
- `home/users/nix` (not `home/users/juan`) — different user settings for the work machine.
- Sway is installed from Nix (`pkgs.sway`), not from apt. The apt package was removed.

## Apply

```bash
home-manager switch --flake .#playa-el-yaque
home-manager build --flake .#playa-el-yaque    # dry run
```
