# canaima

This is the repository for my nixos config files

### Run nixos flake

```bash
sudo nixos-rebuild switch --flake .#canaima
```

### Run home-manager flake

```bash
nix run home-manager/release-25.11 -- switch --flake .#juan
```

```bash
nix run home-manager/release-25.11 -- switch --flake .#nix --impure
```

or

```bash
home-manager switch --flake .#juan
```
