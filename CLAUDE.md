# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Applying Changes

```bash
# NixOS hosts (system + home-manager together)
sudo nixos-rebuild switch --flake .#canaima
sudo nixos-rebuild switch --flake .#sarisarinama

# Standalone Home Manager (non-NixOS)
home-manager switch --flake .#playa-el-yaque

# Dry-run / check without applying
sudo nixos-rebuild dry-activate --flake .#canaima
sudo nixos-rebuild dry-activate --flake .#sarisarinama
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
hosts/<hostname>/                          # Hardware config + host-specific services
  └── imports configuration/<preset>.nix  # OS preset (e.g. budapest.nix) at repo root
        └── nixos/modules/                # Reusable OS-level modules
        └── home-manager integration
              └── configuration/home-configuration/<profile>/
                    └── home/modules/     # Reusable user-level modules
```

`flake.nix` lists hosts; each host imports its OS preset; OS presets integrate Home Manager and point to a home profile.

### hostSpec — global variables module

`home/modules/core/hostSpec/default.nix` is a **Home Manager-only** module (not used in `nixos/`) that defines `options.hostSpec.*` — machine-wide variables consumed across all home modules: `username`, `hostname`, `email`, `terminal`, `terminalAppId`, `menu`, `sshKeyName`, `isNixOS`, `windowManager`, `bluetooth`, `vpn`. Each home profile sets these once; modules read them via `config.hostSpec.*`.

`isNixOS` is the key flag that lets `playa-el-yaque` (Ubuntu) skip NixOS-specific options like systemd services and declarative symlinks that only work on NixOS.

**Rule: all machine-level configuration belongs in `hostSpec`.** Any flag that describes what a machine is or has — active WM, hardware capabilities, enabled features — must be declared as an `options.hostSpec.*` option and set in the profile's `hostSpec { }` block. Never create a separate module-scoped options namespace (e.g. `features.*`) for things that are really machine identity. Modules read `config.hostSpec.*` directly.

### Latest changes

Always check the latest changes.
Always ask if you propose a change if the change was made by me, if the answer is affirmative, update the changes.md and also the .md file of the section that was modified.

Check the changes here [changes](./changes.md)

### Hosts

| Host           | Doc                                                  | OS preset | Home profile  |
| -------------- | ---------------------------------------------------- | --------- | ------------- |
| `canaima`      | [canaima](./hosts/canaima/canaima.md)                | budapest  | playa-el-agua |
| `sarisarinama` | [sarisarinama](./hosts/sarisarinama/sarisarinama.md) | caracas   | playa-caribe  |

### OS Presets

| Preset     | Doc                                     | WM   | Used by      |
| ---------- | --------------------------------------- | ---- | ------------ |
| `budapest` | [budapest](./configuration/budapest.md) | Sway | canaima      |
| `caracas`  | [caracas](./configuration/caracas.md)   | dwl  | sarisarinama |

### Home Profiles

| Profile          | Doc                                                                                   | Host          | Type          |
| ---------------- | ------------------------------------------------------------------------------------- | ------------- | ------------- |
| `playa-el-agua`  | [playa-el-agua](./configuration/home-configuration/playa-el-agua/playa-el-agua.md)    | canaima       | NixOS         |
| `playa-el-yaque` | [playa-el-yaque](./configuration/home-configuration/playa-el-yaque/playa-el-yaque.md) | Ubuntu laptop | standalone HM |
| `playa-caribe`   | [playa-caribe](./configuration/home-configuration/playa-caribe/playa-caribe.md)       | sarisarinama  | NixOS         |

### Modules

#### UI

| Module       | Doc                                                      | Description                        |
| ------------ | -------------------------------------------------------- | ---------------------------------- |
| `Themes`     | [themes](./home/modules/ui/themes/themes.md)             | Base16 theme switcher (dark/light) |
| `Wallpapers` | [wallpapers](./home/modules/ui/wallpapers/wallpapers.md) | Wallpaper switcher                 |
| `Waybar`     | [waybar](./home/modules/ui/waybar/waybar.md)             | Status bar for Sway and Hyprland   |
| `Sway`       | [sway](./home/modules/ui/sway/sway.md)                   | Sway WM user config                |

#### Scripts & Menus

| Module    | Doc                                              | Description                                  |
| --------- | ------------------------------------------------ | -------------------------------------------- |
| `Scripts` | [scripts](./home/modules/scripts/scripts.md)     | Nix-wrapped launcher scripts (menu-agnostic) |
| `Menus`   | [menus](./home/modules/menus/menus.md)           | wofi / bemenu backends; active set via `hostSpec.menu` |

#### Security

| Module | Doc                                        | Description                     |
| ------ | ------------------------------------------ | ------------------------------- |
| `Sops` | [sops](./home/modules/core/sops/sops.md) | Secrets management via sops-nix |

#### Other

| Module       | Doc                                               | Description                           |
| ------------ | ------------------------------------------------- | ------------------------------------- |
| `Browsers`   | [browsers](./home/modules/browsers/README.md)     | Browser configurations                |
| `Quickshell` | [quickshell](./home/modules/quickshell/README.md) | Quickshell status bar (Sway/Hyprland) |

### Key inputs

| Input                  | Purpose                                          |
| ---------------------- | ------------------------------------------------ |
| `kukenan`              | Personal Neovim config flake                     |
| `xremap-flake`         | Key remapping (used in home modules)             |
| `sops-nix` + `secrets` | Secrets management via SSH-accessed private repo |
| `nix-claude-code`      | Claude Code Nix package                          |
| `nixpkgs-unstable`     | Passed as `pkgs-unstable` for select packages    |

`pkgs-unstable` is threaded through `specialArgs` / `extraSpecialArgs` — use it in modules via the function argument, not by importing nixpkgs again.

