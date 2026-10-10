# Dendritic

The idea of this `dendritic` branch is to migrate slowly this config to the dendritic pattern.

## Directory layout

```
.
├── docs/                   reference for humans and AI agents
│   └── dendritic.md
├── modules/                features — the bulk of the config
│   ├── ai/
│   ├── browsers/
│   ├── core/
│   ├── ui/
│   ├── media/
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

#### Browsers

One file per browser under `modules/browsers/`, merged into the `browsers` module. Imported by `canaima` and `mucuchies`. Themes come from sarisarinama (not yet).

- `qutebrowser`: the main browser (`ui.apps.browser`). Tabs on top, shown only with more than one. Adblock on, no autoplay. Quickmarks (`b` / `B` + name) and search engines (`o` + keyword): `nix`, `nixo` (NixOS options), `hm`, `g`; anything else goes to DuckDuckGo.
- `default-browser`: if the host sets `hostspec.defaultBrowser` (a desktop file name), `xdg-open` uses it for links and HTML files (`~/.config/mimeapps.list`). `asus` sets qutebrowser; `mucuchies` leaves it unset, so its own `mimeapps.list` stays.

  | Action                | Keybind                              |
  | --------------------- | ------------------------------------ |
  | previous / next tab   | `alt` + `shift` + `[` / `]`          |
  | move tab left / right | `ctrl` + `alt` + `shift` + `[` / `]` |
  | open video in mpv     | `m` (hint) / `ctrl` + `m` (this tab) |
  | watch live stream     | `,t` (hint) / `,T` (this tab)        |
  | toggle page dark mode | `,d`                                 |

#### Media

One file per feature under `modules/media/`, merged into the `media` module. Imported by `canaima` and `mucuchies`; `browsers` uses it for its mpv and streamlink binds.

- `mpv`: mpv with uosc (controls), thumbfast (seek previews) and mpris (media keys), yt-dlp as its backend, 1080p max, resumes where you stopped. CPU output (`vo=wlshm`) on non-NixOS.
- `twitch`: streamlink plays live streams in that mpv, low latency, ads skipped; chatterino2 for the chat.

#### Workspace

All the modules for work, merged into the `workspace` module and imported by `canaima` and `mucuchies`: editor, git, gh, terminal, multiplexer.

- `editor`: [kukenan](https://github.com/juanalbarran/kukenan) variants `base`, `web`, `rust`, `java`. `EDITOR`/`VISUAL` are `nvim-base`.
- `git`: git with the user name; the email comes from sops (`~/.config/git/sops-data.conf`).
- `gh`: GitHub CLI as `juanalbarran`, with no `gh auth login`. `config.yml` comes from Home Manager (`git_protocol: ssh`); `hosts.yml` is a sops template holding `access_tokens/github_token`, so every `gh` on `PATH` (including the one Claude Code brings) uses it. `gh auth switch`/`login` are refused, since the account is config. Only when the host sets `hostspec.githubUser`: `asus` sets `juanalbarran`; `mucuchies` leaves it unset and keeps its own manual login.
- `terminal`: foot, the main terminal (`ui.apps.terminal`), with JetBrainsMono Nerd Font 12 and 10k lines of scrollback. Colors are foot's defaults until sarisarinama themes it.

  | Action                          | Keybind                      |
  | ------------------------------- | ---------------------------- |
  | fullscreen                      | `ctrl` + `return`            |
  | newline in TUIs (sent as CSI-u) | `shift` + `return`           |
  | new terminal in the same dir    | `ctrl` + `shift` + `n`       |
  | copy / paste                    | `ctrl` + `shift` + `c` / `v` |
  | open a URL (jump labels)        | `ctrl` + `shift` + `o`       |
  | copy a URL                      | `ctrl` + `shift` + `y`       |
  | copy a git hash                 | `ctrl` + `shift` + `g`       |
  | font size up / down / reset     | `ctrl` + `=` / `-` / `0`     |

  An unfocused foot window turns urgent on the bell.

- `multiplexer`: tmux, needed by the sarisarinama project menu. Status bar on top: `[session]` on the left, the window list centred (current bold, others dim), and a blank line under it as a gap. No colours: the theme will come from sarisarinama. Windows and panes start at 1, mouse on, vi copy mode, `y` copies to the system clipboard.

  | Action                           | Keybind                        |
  | -------------------------------- | ------------------------------ |
  | previous window                  | `alt` + `shift` + `[`          |
  | next window                      | `alt` + `shift` + `]`          |
  | move window to the previous slot | `ctrl` + `alt` + `shift` + `[` |
  | move window to the next slot     | `ctrl` + `alt` + `shift` + `]` |
  | kill pane / session (confirms)   | `ctrl` + `b` then `x` / `X`    |
  | copy mode: select / copy         | `v` / `y`                      |

  Each window keybind is bound under every name a terminal may send for it (`M-{`, `M-S-{`, `M-S-[`), with extended keys enabled for foot and ghostty.
