# caracas

Minimalist suckless NixOS OS preset. Named after Caracas.
Used by: [`sarisarinama`](../hosts/sarisarinama/sarisarinama.md).

## What it imports

| Module                        | Purpose                                          |
| ----------------------------- | ------------------------------------------------ |
| `nixos/modules/common`        | Fonts, localization, networking, programs, UI    |
| `nixos/modules/ui/dwl`        | dwl WM (custom build with patches)               |
| `nixos/modules/common/laptop.nix` | Laptop-specific settings (power, etc.)       |
| `nixos/users/juan.nix`        | System user `juan`                               |

## nixos/modules/ui/dwl

Builds a custom `dwl` from nixpkgs with two patches applied:
- **movestack** — move windows up/down the stack
- **warpcursor** — warp cursor to focused window

Starts the session via `systemctl --user start dwl-session.target` and exports
`WAYLAND_DISPLAY` into the user systemd environment. Display manager is `ly`.
Also installs `wl-clipboard`, `wlr-randr`, `wlrctl`.

## Compared to budapest

| Feature          | budapest       | caracas         |
| ---------------- | -------------- | --------------- |
| WM               | Sway           | dwl             |
| Display manager  | `ly`           | `ly`            |
| Resource usage   | full-featured  | minimal         |
| GTK integration  | yes            | no              |
| XDG portals      | wlr + gtk      | none            |
| Laptop extras    | no             | yes             |

## Home Manager

The `sarisarinama` host points `home-manager.users.juan` to
`configuration/home-configuration/playa-caribe/`.
