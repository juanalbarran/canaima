# Core

This is the `core` module, contains the modules that are core in nixos and nix configuration

- `sops`: [sops-nix](https://github.com/Mic92/sops-nix) decrypts secrets from the private `fortin-de-la-galera` repo (input `secrets`) at activation, using the age key at `~/.config/sops/age/keys.txt`. Deploys the SSH key `private_keys/<hostspec.sshKeyName>` to `~/.ssh/`, the GitHub token for nix (`access-tokens`) and the git email (`hostspec.emailSecret`).
- `ssh`: openssh + agent (NixOS), and `~/.ssh/config` with `github.com` using `~/.ssh/<hostspec.sshKeyName>`.

  | Preset       | `sshKeyName`     | `emailSecret`    |
  | ------------ | ---------------- | ---------------- |
  | canaima      | `playa-el-agua`  | `personal/email` |
  | sarisarinama | `playa-el-yaque` | `work/email`     |
  - `printing` (NixOS only): CUPS with Canon's `cnijfilter2` driver (for the TS200), `ipp-usb` for driverless USB printers, avahi (mDNS) and `system-config-printer` (Print Settings), as in omarchy. `cups-browsed` is off. `modules/core/printers.nix` also adds the Printers row to the shell menu.
