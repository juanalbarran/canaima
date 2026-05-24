# playa-caribe

Minimal suckless home profile. Named after Playa Caribe, Margarita Island.
Host: [`sarisarinama`](../../../hosts/sarisarinama/sarisarinama.md) · OS preset: [`caracas`](../../caracas.md).

## hostSpec

| Option          | Value                          |
| --------------- | ------------------------------ |
| `username`      | `juan`                         |
| `hostname`      | `sarisarinama`                 |
| `email`         | personal                       |
| `terminal`      | `foot`                         |
| `terminalAppId` | `foot`                         |
| `menu`          | `bemenu`                       |
| `sshKeyName`    | `playa-caribe`                 |
| `isNixOS`       | `true` (default)               |

## Modules imported

| Module                              | Purpose                          |
| ----------------------------------- | -------------------------------- |
| `home/modules/core`                 | gc, ssh, sops, hostSpec, packages |
| `home/modules/browsers/qutebrowser` | qutebrowser only                 |
| `home/modules/browsers/brave.nix`   | Brave browser                    |
| `home/modules/terminals/tmux`       | tmux multiplexer                 |
| `home/modules/terminals/fastfetch`  | System info display              |
| `home/modules/terminals/starship`   | Shell prompt                     |
| `home/modules/terminals/foot`       | foot terminal                    |
| `home/modules/scripts`              | Personal scripts                 |
| `home/modules/ui/themes`            | Theme system                     |
| `home/modules/menus/bemenu`         | bemenu launcher                  |
| `home/users/juan`                   | HM user settings                 |

## Notes

- No WM home module — dwl is managed entirely at the NixOS level via `caracas` preset.
- No waybar, no wallpaper module.
- Minimal browser set: qutebrowser + Brave only (no full browsers module).
- Depends on the private `fortin-de-la-galera` secrets repo (via sops).
