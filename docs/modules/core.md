# Core

This is the `core` module, contains the modules that are core in nixos and nix configuration

- `sops`: [sops-nix](https://github.com/Mic92/sops-nix) decrypts secrets from the private `fortin-de-la-galera` repo (input `secrets`) at activation, using the age key at `~/.config/sops/age/keys.txt`. Deploys the SSH key `private_keys/<hostspec.sshKeyName>` to `~/.ssh/`, the GitHub token for nix (`access-tokens`) and the git email (`hostspec.emailSecret`).
- `ssh`: openssh + agent (NixOS), and `~/.ssh/config` with `github.com` using `~/.ssh/<hostspec.sshKeyName>`, plus the aliases `github-nix` (`~/.ssh/nix`) and `github-ctwo` (`~/.ssh/ctwo`) for remotes like `git@github-ctwo:org/repo`. Those two keys aren't in sops, they live on the machine.

  | Preset       | `sshKeyName`     | `emailSecret`    |
  | ------------ | ---------------- | ---------------- |
  | canaima      | `playa-el-agua`  | `personal/email` |
  | sarisarinama | `playa-el-yaque` | `work/email`     |
- `generic-linux` (non-NixOS only): Home Manager's `targets.genericLinux`, so Nix apps work on Ubuntu: `XDG_DATA_DIRS`, terminfo, locales, and GPU drivers at `/run/opengl-driver` (quickshell and mpv need them). After a switch that changes the drivers, Home Manager prints a `sudo .../non-nixos-gpu-setup` command to run once.
- `laptop` (NixOS only): UPower (battery state) and power-profiles-daemon (power profiles) for the shell's battery widget and panel; with `hostspec.isDocked`, logind ignores the lid switch. Don't enable TLP or auto-cpufreq alongside power-profiles-daemon, they conflict. On Ubuntu (sarisarinama) both daemons ship with the distro.
  - `printing` (NixOS only): CUPS with Canon's `cnijfilter2` driver (for the TS200), `ipp-usb` for driverless USB printers, avahi (mDNS) and `system-config-printer` (Print Settings), as in omarchy. `cups-browsed` is off. `modules/core/printers.nix` also adds the Printers row to the shell menu.
