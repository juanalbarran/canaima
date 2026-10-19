# Sarisarinama

This document will set some guidelines of the `preset` sarisarinama. This is a "on progress document"

## Prerequisites

This section contains the prerequisites to use this preset in a linux machine.

### Programs to install

- Nix: `nix` package manager of course, it is the more important piece here.
- From apt: `network-manager-openvpn` (NetworkManager loads the distro's plugin, not Nix's).

### After a switch

- If Home Manager warns that the GPU drivers are missing or outdated, run the `sudo .../non-nixos-gpu-setup` command it prints, so `/run/opengl-driver` points at the drivers of this nixpkgs. Quickshell (the shell) and mpv need them.
