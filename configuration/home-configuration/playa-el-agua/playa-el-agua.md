# playa-el-agua

Personal NixOS home profile. Named after Playa El Agua, Margarita Island.
Host: [`canaima`](../../../hosts/canaima/canaima.md) · OS preset: [`budapest`](../../budapest.md).

## hostSpec

| Option          | Value                          |
| --------------- | ------------------------------ |
| `username`      | `juan`                         |
| `hostname`      | `canaima`                      |
| `email`         | personal                       |
| `terminal`      | `foot`                         |
| `terminalAppId` | `foot`                         |
| `menu`          | `bemenu`                       |
| `sshKeyName`    | `playa-el-agua`                |
| `isNixOS`       | `true`                         |

## Features

| Option                    | Value   |
| ------------------------- | ------- |
| `features.windowManager`  | `sway`  |

## Modules imported

| Module                          | Purpose                               |
| ------------------------------- | ------------------------------------- |
| `home/modules/core`             | gc, ssh, sops, hostSpec, packages     |
| `home/modules/browsers`         | All browsers                          |
| `home/modules/terminals`        | All terminals                         |
| `home/modules/ui/sway`          | Sway HM config, packages              |
| `home/modules/ui/swaylock`      | Lock screen                           |
| `home/modules/ui/wallpapers`    | Wallpaper management                  |
| `home/modules/ui/waybar`        | Status bar                            |
| `home/modules/ui/themes`        | Theme system (dark/light toggle)      |
| `home/modules/kanshi`           | Output management (under review)      |
| `home/modules/menus/bemenu`     | bemenu launcher                       |
| `home/modules/scripts`          | Personal scripts                      |
| `home/modules/ai`               | Opencode AI                           |
| `home/users/juan`               | HM user settings                      |

## Notes

- Depends on the private `fortin-de-la-galera` secrets repo (via sops). Requires SSH
  access to that repo to evaluate.
- `kanshi` is imported but its usefulness is under review — may be removed.
- No Hyprland module here; `features.windowManager = "sway"` is the only WM.
