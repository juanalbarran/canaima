# canaima

This is the repository for my nixos config files

### Run nixos flake

```bash
sudo nixos-rebuild switch --flake .#canaima
```

```bash
sudo nixos-rebuild switch --flake .#suckless
```

### Run home-manager flake

```bash
nix run home-manager/release-25.11 -- switch --flake .#juan
```

```bash
nix run home-manager/release-25.11 -- switch --flake .#nix --impure
```
