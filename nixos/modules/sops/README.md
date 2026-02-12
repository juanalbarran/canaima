# Sops-Nix

So with sops (SecretsOPeratioS) we are gonna handle the secrets in the whole ecosystem.
This will work as a guide about how to add more hosts to the secrets manager.

The secrets are being stored in a `secrets.yaml` that lies in the private repository `fortin-de-la-galera`

# Instructions

## Prerequisites

[sops](https://github.com/getsops/sops) File encoder
[age](https://github.com/FiloSottile/age) Encryptor
[ssh-to-age](https://github.com/Mic92/ssh-to-age) transform `ssh` keys to `age`
[openssh](https://www.openssh.org) yeah the ssh

These prerequisites are being handled here in this directory: [nixos/modules/sops](default.nix)

Also these two should be added to the `flakes.nix`

[sops-nix](https://github.com/mic92/sops-nix) The sops implementation in nix
[fortin-de-la-galera](https://github.com/juanalbarran/fortin-de-la-galera) My private secret repository

### sops-nix

```nix
# flake.nix
# ...
inputs = {
    #...
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
};
#...
```

### fortin-de-la-galera

```nix
inputs = {
    #...
    secrets = {
        url = "github:juanalbarran/fortin-de-la-galera";
        flake = false;
    };
};
#...
```

## Creating the `age` key

We need to create the `age` key we do it like this:

### User level age key

First we create the directory `~/.config/sops/age`

```bash
mkdir -p .config/sops/age
```

Next we create the `age` key. In this file both public and private keys are gonna be there

```bash
age-keygen -o ~/.config/sops/age/keys.txt
```

### Host level `age` key

For this we create an `age` key from the `/etc/ssh/ssh_host_ed25519_key.pub` (this is why we need openssh installed :P)

```bash
cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
```

The `age` keys that we just created are the ones that will allows us to encript and decript the `.sops.yaml` file

## The `.sops.yaml` file

After we get the `age` key we go to the `fortin-de-la-galera` repository (we need to have access to it) here we will add the created key to the file

```yaml
# .sops/.yaml
keys:
  - &users:
    - &playa-el-yaque <playa-el-yaque-age-key>
    - $<the-user-we-are-configuring> <the-public-user-level-age-key-we-just-created>
  - &hosts:
    - &<the-host-we-are-configuring> <the-public-age-key-we-just-created-from-the-ssh-pub-key>
creation_rules:
  - path_regex: secrets.yaml$
    key_groups:
      - age:
          - *playa-el-yaque
          = *<the-user-we-are-configuring>
          - *<the-host-we-are-configuring>
```

## `secrets.yaml`

The next step is just to update the keys with the `sops` command, for this you need to be in `fortin-de-la-galera` repository

```bash
sops updatekeys secrets.yaml

```

Finally we push the keys to the repository origin

## Troubleshooting

I you get the error that the `service.sops` couldn't be restarted just try to run the build again with the --refresh flag

```bash
home-manager switch --flake --refresh .#playa-el-yaque
```

If it does not work then

```bash
systemctrl --user reset-failed
```

And run again

```bash
home-manager switch --flake .#playa-el-yaque
```
