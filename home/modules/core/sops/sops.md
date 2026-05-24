# Sops

Home Manager module for secrets management. Uses [sops-nix](https://github.com/mic92/sops-nix)
to decrypt secrets at activation time. Secrets are stored encrypted in the private
[fortin-de-la-galera](https://github.com/juanalbarran/fortin-de-la-galera) repository and
decrypted using an `age` key derived from the host's SSH key.

Used by: `playa-el-agua`, `playa-el-yaque`.

## Architecture

```
fortin-de-la-galera (private repo)
└── secrets.yaml          ← all secrets encrypted with age
└── .sops.yaml            ← key registry: which age keys can decrypt

home/modules/core/sops/
└── default.nix           ← sops-nix HM module; declares secrets and templates
```

The module reads from `hostSpec` to know which SSH key name and email to use, then
declares each secret's destination path and access mode. sops-nix decrypts secrets
from the nix store at `home-manager switch` time via a systemd user service.

## Managed Secrets

| Secret path                          | Deployed to                              | Notes                  |
| ------------------------------------ | ---------------------------------------- | ---------------------- |
| `private_keys/<sshKeyName>`          | `~/.ssh/<sshKeyName>`                    | mode 0400              |
| `access_tokens/github_token`         | template → `~/.config/access_tokens/github_token` | used by nix extra-options |
| `work/email`                         | template → `~/.config/git/sops-data.conf` | git `user.email`       |
| `personal/email`                     | template → `~/.config/git/sops-data.conf` | git `user.email`       |
| `vpn/nix`                            | `~/.config/openvpn/nix.conf`             | OpenVPN config         |
| `access_tokens/wireguard/private_key`| template → `~/.config/wireguard/wg0.conf`| WireGuard interface    |
| `access_tokens/wireguard/preshared_key` | template → `~/.config/wireguard/wg0.conf` | WireGuard peer       |

## Prerequisites

| Tool          | Purpose                                  |
| ------------- | ---------------------------------------- |
| `sops`        | Encrypt / decrypt secret files           |
| `age`         | Encryption backend used by sops          |
| `ssh-to-age`  | Converts an SSH ed25519 key to an age key |
| `openssh`     | Provides the host SSH key                |

All four are installed via `home.packages` in `default.nix`.

The flake also requires two inputs in `flake.nix`:

```nix
inputs = {
  sops-nix = {
    url = "github:mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  secrets = {
    url = "github:juanalbarran/fortin-de-la-galera";
    flake = false;
  };
};
```

## Adding a New Host

### 1. Create the age key

**User-level key** (used by the HM module):
```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```

**Host-level key** (derived from the SSH host key):
```bash
cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
```

### 2. Register the keys in `.sops.yaml`

In the `fortin-de-la-galera` repository, add both keys:

```yaml
# .sops.yaml
keys:
  - &users:
    - &playa-el-yaque <existing-age-key>
    - &<new-host-user> <new-user-level-age-public-key>
  - &hosts:
    - &<new-host> <new-host-level-age-public-key>
creation_rules:
  - path_regex: secrets.yaml$
    key_groups:
      - age:
          - *playa-el-yaque
          - *<new-host-user>
          - *<new-host>
```

### 3. Re-encrypt `secrets.yaml`

From inside the `fortin-de-la-galera` repository:
```bash
sops updatekeys secrets.yaml
```

Then commit and push.

## Troubleshooting

**`sops-nix.service` fails to start after `home-manager switch`:**
```bash
home-manager switch --flake .#playa-el-yaque --refresh
```

If that doesn't work, reset the failed unit and retry:
```bash
systemctl --user reset-failed
home-manager switch --flake .#playa-el-yaque
```
