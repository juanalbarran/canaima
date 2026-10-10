# Dendritic

The idea of this `dendritic` branch is to migrate slowly this config to the dendritic pattern.

## Directory layout

```
.
├── docs/                   reference for humans and AI agents
│   └── dendritic.md
├── modules/                features — the bulk of the config
│   ├── ai/
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

#### AI

All the AI apps, one directory per app under `modules/ai/`, merged into the `ai` module. Imported by `canaima` and `mucuchies`.

- `claude-code`: [Claude Code](https://claude.com/claude-code) through Home Manager's `programs.claude-code`, with the binary from the [nix-claude-code](https://github.com/ryoppippi/nix-claude-code) flake input (official prebuilt, newer than nixpkgs). Update it with `nix flake update nix-claude-code`.

| Command  | Source                                 | Description                              |
| -------- | -------------------------------------- | ---------------------------------------- |
| `/issue` | `modules/ai/claude/_commands/issue.md` | Show a GitHub issue and start solving it |

#### Workspace

All the modules for work: editor, multiplexer, terminal

- `editor`: [kukenan](https://github.com/juanalbarran/kukenan) variants `base`, `web`, `rust`, `java`. `EDITOR`/`VISUAL` are `nvim-base`. Imported by `canaima`.
- `git`: git with the user name; the email comes from sops (`~/.config/git/sops-data.conf`). Imported by `canaima` and `sarisarinama`.
- `terminal`: foot, the main terminal (`ui.apps.terminal`), with JetBrainsMono Nerd Font 12 and 10k lines of scrollback. Colors are foot's defaults until sarisarinama themes it. Imported by `canaima` and `mucuchies`.
  | Action | Keybind |
  | ------------------------------- | ---------------------------- |
  | fullscreen | `ctrl` + `return` |
  | newline in TUIs (sent as CSI-u) | `shift` + `return` |
  | new terminal in the same dir | `ctrl` + `shift` + `n` |
  | copy / paste | `ctrl` + `shift` + `c` / `v` |
  | open a URL (jump labels) | `ctrl` + `shift` + `o` |
  | copy a URL | `ctrl` + `shift` + `y` |
  | copy a git hash | `ctrl` + `shift` + `g` |
  | font size up / down / reset | `ctrl` + `=` / `-` / `0` |

An unfocused foot window turns urgent on the bell.

- `multiplexer`: tmux, needed by the sarisarinama project menu. Imported by `canaima`.

  | Action                           | Keybind                        |
  | -------------------------------- | ------------------------------ |
  | previous window                  | `alt` + `shift` + `[`          |
  | next window                      | `alt` + `shift` + `]`          |
  | move window to the previous slot | `ctrl` + `alt` + `shift` + `[` |
  | move window to the next slot     | `ctrl` + `alt` + `shift` + `]` |

  Each is bound under every name a terminal may send for it (`M-{`, `M-S-{`, `M-S-[`), with extended keys enabled for foot and ghostty.
