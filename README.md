# canaima

This is the repository for my nixos config files

### Run nixos flake

```bash
sudo nixos-rebuild switch --flake .#canaima
```

### Run home-manager flake

```bash
home-manager switch --flake .#juan
```

or

```bash
nix run home-manager/release-25.05 -- switch --flake .#juan
```
