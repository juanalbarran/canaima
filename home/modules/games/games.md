# Games

Home Manager module for gaming. Installs [Lutris](https://lutris.net), which is used to install
Battle.net and World of Warcraft. On non-NixOS hosts it also provides the 32-bit GPU drivers
that Home Manager's own GPU support leaves out.

## File Structure

```
home/modules/games/
├── default.nix   # Lutris (from pkgs-unstable); imports gpu-32.nix
└── gpu-32.nix    # 32-bit GPU drivers at /run/opengl-driver-32 (non-NixOS only)
```

Used by: `playa-el-yaque`. Not imported on `playa-el-agua` or `playa-caribe` yet.

## Lutris

Lutris installs Windows games through its own Wine/Proton, DXVK (DirectX 9–11 → Vulkan) and
VKD3D (DirectX 12 → Vulkan) runners, which it downloads at runtime. The nixpkgs `lutris`
package is an FHS sandbox (bubblewrap), so those prebuilt binaries find libraries under
`/usr/lib` and `/usr/lib32` as they expect.

**Why `pkgs-unstable`:** the Lutris servers report the current client version
(`~/.cache/lutris/versions.json` → `client_version`) and older clients are shown as
"no longer supported". nixos-25.11 ships 0.5.19; the servers expected 0.5.22.

A Lutris account is **not** needed. It only syncs the game library.

## 32-bit GPU drivers (`gpu-32.nix`)

Nix programs do not use the host's graphics drivers. They load them from
`/run/opengl-driver` (64-bit) and `/run/opengl-driver-32` (32-bit).

| Path                    | NixOS                    | Ubuntu (`playa-el-yaque`)               |
| ----------------------- | ------------------------ | --------------------------------------- |
| `/run/opengl-driver`    | `hardware.graphics`      | HM `targets.genericLinux.gpu`           |
| `/run/opengl-driver-32` | `hardware.graphics.enable32Bit` | **`gpu-32.nix`** (HM has no 32-bit option) |

`Battle.net-Setup.exe` is a 32-bit Windows program. Without a 32-bit Vulkan driver, DXVK
fails with:

```
err:   DxvkInstance::createInstance: Failed to create Vulkan instance
err:   Failed to initialize DXVK.
```

`gpu-32.nix` does the same thing as HM's 64-bit setup, but with `pkgs.pkgsi686Linux.mesa`:

- A systemd unit `non-nixos-gpu-32.service` runs `ln -nsf <mesa-32> /run/opengl-driver-32`
  at boot (`/run` is a tmpfs, so the link must be recreated every boot).
- A setup script `non-nixos-gpu-32-setup` installs the unit and registers a gcroot, so
  `nix-collect-garbage` does not delete drivers the unit still points to. It needs root,
  so it must be run by hand.
- An activation check warns after `home-manager switch` when the link is missing or points
  to an older Mesa.

The whole file is wrapped in `lib.mkIf (!config.hostSpec.isNixOS)`. On NixOS it does nothing.

### Setup (once, and again after a Mesa update)

```bash
home-manager switch --flake .#playa-el-yaque
sudo ~/.nix-profile/bin/non-nixos-gpu-32-setup   # needs a real terminal (not `!` in Claude Code)
```

### Verify

```bash
readlink /run/opengl-driver-32                      # → /nix/store/…-mesa-<version>
systemctl is-active non-nixos-gpu-32.service        # → active
ls /etc/systemd/system/multi-user.target.wants/ | grep non-nixos-gpu-32
```

`systemctl is-enabled` reports `alias` rather than `enabled`. This is only how systemd labels a
unit file that is a symlink into `/nix/store`. The unit is in `multi-user.target.wants` and
runs at boot.

## Installing World of Warcraft

1. Lutris → **+** → **Search the Lutris website for installers** → **Battle.net** → **Install**.
2. Log in to Battle.net → install **World of Warcraft** → **Play**.

## Troubleshooting

- **Black screen / crash on launch:** add `-d3d11` as a command-line argument in the
  Battle.net game settings (DirectX 11 is more stable than 12 on Intel graphics).
- **Install hangs after the Battle.net login:** the installer's last step (`wineboot -k`)
  waits for the whole Wine session to exit, but Battle.net auto-starts minimized to the tray and
  keeps `Agent.exe` running. Close Battle.net from the tray, or stop that prefix's `wineserver`
  and its leftover processes **by PID**. `pkill -f Agent.exe` can also match unrelated
  processes whose command line contains that text.
- **Low FPS:** expected on Iris Xe. Lower *Graphics Quality* and *Render Scale*.
- **Harmless log noise:** `glib-networking … undefined symbol`, `hu_HU.UTF-8` locale
  generation, `unable to use parent for game drive`, and the Battle.net *source*
  (library import) protobuf warning.

## Steam

Steam is **not** in this module:

- **NixOS:** `nixos/modules/game/steam/default.nix`. `programs.steam` is a NixOS option. It
  enables 32-bit graphics, controller udev rules and firewall ports, which need root.
- **Ubuntu:** installed with apt (`steam-installer`). It uses Ubuntu's own 32-bit Mesa
  (`libgl1-mesa-dri:i386`, `mesa-vulkan-drivers:i386`).

## Future Improvements

- **Add to `playa-el-agua` and `playa-caribe`:** import `home/modules/games`. On NixOS
  `gpu-32.nix` is a no-op because `hardware.graphics.enable32Bit` already provides
  `/run/opengl-driver-32`.
- **Rename `nixos/modules/game` → `nixos/modules/games`:** add a `default.nix` importing
  `./steam` so both sides match. This also fixes `sarisarinama`: `caracas.nix` imports
  `nixos/modules/game`, which has no `default.nix`.
