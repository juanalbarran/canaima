# budapest

Feature-rich NixOS OS preset. Named after Budapest.
Used by: [`canaima`](../hosts/canaima/canaima.md).

## What it imports

| Module                        | Purpose                                                  |
| ----------------------------- | -------------------------------------------------------- |
| `nixos/modules/ui/sway`       | Sway WM, polkit, rtkit, XDG portals, `light` brightness |
| `nixos/modules/common`        | Fonts, localization, networking, programs, UI base       |
| `nixos/users/juan.nix`        | System user `juan`                                       |

## nixos/modules/common breakdown

| Sub-module          | Provides                                              |
| ------------------- | ----------------------------------------------------- |
| `font.nix`          | System fonts                                          |
| `localization.nix`  | Locale, timezone                                      |
| `networking.nix`    | NetworkManager, hostname                              |
| `programs.nix`      | System-level programs (e.g. `dconf`)                  |
| `ui.nix`            | Shared UI base (graphics, dbus, etc.)                 |

Also sets: `nix.settings.experimental-features = ["nix-command" "flakes"]`,
`nixpkgs.config.allowUnfree = true`, and `EDITOR`/`VISUAL` to `nvim-base`.

## nixos/modules/ui/sway

Enables Sway at the NixOS level:
- `programs.sway.enable = true` with GTK wrapper features
- `programs.light.enable = true` (backlight control)
- `security.polkit.enable = true` + `security.rtkit.enable = true`
- `xdg.portal` with `wlr` (screen sharing) and `xdg-desktop-portal-gtk`

## Home Manager

Home Manager is wired in through this preset. The `canaima` host points
`home-manager.users.juan` to `configuration/home-configuration/playa-el-agua/`.
