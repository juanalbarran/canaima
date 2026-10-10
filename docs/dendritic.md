# Dendritic

The idea of this `dendritic` branch is to migrate slowly this config to the dendritic pattern.

## Directory layout

```
.
├── docs/                   reference for humans and AI agents
│   └── dendritic.md
├── modules/                features — the bulk of the config
│   ├── core/
│   ├── ui/
│   ├── meta/
│   └── workspace/
├── presets/                named bundles of features
│   ├── canaima.nix
│   └── mucuchies.nix
├── hosts/                  machines, and only what is true of one machine
│   └── asus/
├── users/                  users, the main one, my personal, and those related with work
│   ├── juan.nix
│   └── work/
│       └── juan-albarran.nix
├── flake.nix
└── flake.lock
```

### Presets

| Name         | User          | Description                            |
| ------------ | ------------- | -------------------------------------- |
| Canaima      | juan          | It's the preset for my personal laptop |
| Sarisarinama | juan-albarran | It's the preset for my work laptop     |

#### Canaima

Canaima will contain the configuration for my personal laptop.
The more important thing about this is that my personal laptop will run `NixOS`

#### Mucuchies

This preset will be used for all the laptops that i'll use that uses linux and dont use the `NixOS` distribution.
It contains it's own [document](./sarisarinama.md)

### Modules

Here are the most important modules and a brief explanation

#### Core

This is the `core` module, contains the modules that are core in nixos and nix configuration

- `sops`: [sops-nix](https://github.com/Mic92/sops-nix) decrypts secrets from the private `fortin-de-la-galera` repo (input `secrets`) at activation, using the age key at `~/.config/sops/age/keys.txt`. Deploys the SSH key `private_keys/<hostspec.sshKeyName>` to `~/.ssh/`, the GitHub token for nix (`access-tokens`) and the git email (`hostspec.emailSecret`).
- `ssh`: openssh + agent (NixOS), and `~/.ssh/config` with `github.com` using `~/.ssh/<hostspec.sshKeyName>`.

  | Preset       | `sshKeyName`     | `emailSecret`    |
  | ------------ | ---------------- | ---------------- |
  | canaima      | `playa-el-agua`  | `personal/email` |
  | sarisarinama | `playa-el-yaque` | `work/email`     |

#### UI

Contains all the modules for `ui`. More info here [UI](./ui.md)

#### Workspace

All the modules for work: editor, multiplexer

- `editor`: [kukenan](https://github.com/juanalbarran/kukenan) variants `base`, `web`, `rust`, `java`. `EDITOR`/`VISUAL` are `nvim-base`. Imported by `canaima`.
- `git`: git with the user name; the email comes from sops (`~/.config/git/sops-data.conf`). Imported by `canaima` and `sarisarinama`.
- `multiplexer`: tmux, needed by the sarisarinama project menu. Imported by `canaima`.

  | Action                           | Keybind                        |
  | -------------------------------- | ------------------------------ |
  | previous window                  | `alt` + `shift` + `[`          |
  | next window                      | `alt` + `shift` + `]`          |
  | move window to the previous slot | `ctrl` + `alt` + `shift` + `[` |
  | move window to the next slot     | `ctrl` + `alt` + `shift` + `]` |

  Each is bound under every name a terminal may send for it (`M-{`, `M-S-{`, `M-S-[`), with extended keys enabled for foot and ghostty.
