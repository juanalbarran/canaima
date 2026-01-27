# canaima

This is the repository for my [NixOS](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager) files.
This is mainly divided in host configuration and home configuration

**Home Configuration:** Handles User-lever applications, dotfiles and theming.

## 󰪫 Host configurations

Handles OS-level operations (Bootloader, Kernel, Hardware, Window Managers)

### Canaima

Canaima is meant to be the configuration that i use in my personal laptop with NixOS, it was working before with `hyprland`, but my old laptop is too slow for it, so now i'm using `sway`

### Suckless

I wanted a config that does not take much from my old laptop so i started to use this, as window manager there is `dwm` as menu `dmenu` of course and as terminal there is `st`
So far it's ok but it needs more work.
All of this is being handled as os level (`NixOS`) because the idea of using suckless software is for old laptops like my old one

### Run nixos flake

```bash
sudo nixos-rebuild switch --flake .#canaima
```

```bash
sudo nixos-rebuild switch --flake .#suckless
```

## 󰋜 Home configurations

Handles User-lever applications, dotfiles and theming.

### Run home-manager flake

```bash
home-manager switch --flake .#juan
```

```bash
home-manager switch --flake .#nix --impure
```
