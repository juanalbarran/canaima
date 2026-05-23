# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Applying Changes

```bash
# NixOS hosts (system + home-manager together)
sudo nixos-rebuild switch --flake .#canaima
sudo nixos-rebuild switch --flake .#sarisarinama

# Standalone Home Manager (non-NixOS)
home-manager switch --flake .#playa-el-agua
home-manager switch --flake .#playa-el-yaque

# Dry-run / check without applying
sudo nixos-rebuild dry-activate --flake .#canaima
sudo nixos-rebuild dry-activate --flake .#sarisarinama
home-manager build --flake .#playa-el-agua
home-manager build --flake .#playa-el-yaque
```

## Architecture

This is a Nix flake managing two NixOS machines and two standalone Home Manager setups.

### Naming conventions

- **NixOS configurations** are named after cities: `canaima` (main laptop), `sarisarinama` (older Asus).
- **High-level OS presets** are named after capitals: `budapest` (feature-rich, Sway WM), `caracas` (minimalist, suckless/dwl).
- **Home Manager profiles** are named after beaches in Margarita Island: `playa-el-agua` (personal NixOS, host `canaima`), `playa-el-yaque` (work Ubuntu laptop, standalone HM), `playa-caribe` (suckless/minimal NixOS, host `sarisarinama`).

### Composition layers

```
hosts/<hostname>/          # Hardware config + host-specific services
  └── configuration/<preset>.nix      # OS preset (e.g. budapest.nix)
        └── nixos/modules/            # Reusable OS-level modules
        └── home-manager integration
              └── configuration/home-configuration/<profile>/
                    └── home/modules/ # Reusable user-level modules
```

`flake.nix` lists hosts; each host imports its OS preset; OS presets integrate Home Manager and point to a home profile.

### hostSpec — global variables module

`home/modules/core/hostSpec/default.nix` is a **Home Manager-only** module (not used in `nixos/`) that defines `options.hostSpec.*` — machine-wide variables consumed across all home modules: `username`, `hostname`, `email`, `terminal`, `terminalAppId`, `menu`, `sshKeyName`, `isNixOS`. Each home profile sets these once; modules read them via `config.hostSpec.*`.

`isNixOS` is the key flag that lets `playa-el-yaque` (Ubuntu) skip NixOS-specific options like systemd services and declarative symlinks that only work on NixOS.

### Theme System

Check it here [themes](./home/modules/ui/themes/THEMES.md)

### Wallpaper System

Check it here [wallpapers](./home/modules/ui/wallpapers/WALLPAPERS.md)

### Scripts

Check it here [scripts](./home/modules/scripts/SCRIPTS.md)

### Menu System

Check it here [menus](./home/modules/menus/MENUS.md)

### Key inputs

| Input                  | Purpose                                          |
| ---------------------- | ------------------------------------------------ |
| `kukenan`              | Personal Neovim config flake                     |
| `xremap-flake`         | Key remapping (used in home modules)             |
| `sops-nix` + `secrets` | Secrets management via SSH-accessed private repo |
| `nix-claude-code`      | Claude Code Nix package                          |
| `nixpkgs-unstable`     | Passed as `pkgs-unstable` for select packages    |

`pkgs-unstable` is threaded through `specialArgs` / `extraSpecialArgs` — use it in modules via the function argument, not by importing nixpkgs again.

### Secrets

`home/modules/core/sops/` and anything under `home/modules/work/` depend on the private `fortin-de-la-galera` repo (the `secrets` flake input, fetched over SSH). Evaluating these modules requires SSH access to that repo. If working offline or without the key, avoid rebuilding configs that include those modules (`playa-el-agua`, `playa-el-yaque`).
