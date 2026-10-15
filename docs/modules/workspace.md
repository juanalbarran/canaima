# Workspace

All the modules for work, merged into the `workspace` module and imported by `canaima` and `mucuchies`: editor, git, gh, terminal, multiplexer, fish, fastfetch, cli tools.

- `fish`: the interactive shell: foot and every tmux pane start fish. bash stays the login shell (greetd, TTY, SSH) and keeps `~/.profile`, so POSIX login scripts work; on `mucuchies` it is also the login shell at `~/.nix-profile/bin/bash`. Home Manager's session variables (`EDITOR`, …) reach fish too.
- `fastfetch`: same as main (small logo, boxed list in `fastfetch/_modules.nix`), shown as fish's greeting in every new shell.
- `cli-tools`: `bat`, `lazygit` (`lg` changes to the repo you leave in) and `yazi` (shows hidden files; `y` changes to the directory you quit in).
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

- `multiplexer`: tmux, needed by the sarisarinama project menu. Status bar on top: `[session]` on the left, the window list centred by name only, without numbers (current bold, others dim), and a blank line under it as a gap. No colours: the theme will come from sarisarinama. Windows and panes start at 1, mouse on, vi copy mode, `y` copies to the system clipboard.

  | Action                           | Keybind                                |
  | -------------------------------- | -------------------------------------- |
  | previous window                  | `alt` + `shift` + `[`                  |
  | next window                      | `alt` + `shift` + `]`                  |
  | move window to the previous slot | `ctrl` + `alt` + `shift` + `[`         |
  | move window to the next slot     | `ctrl` + `alt` + `shift` + `]`         |
  | move to pane / nvim split        | `ctrl` + `h` / `j` / `k` / `l`         |
  | back to the previous pane        | `ctrl` + `\`                           |
  | resize pane                      | `ctrl` + `alt` + `h` / `j` / `k` / `l` |
  | clear the shell (`ctrl` + `l`)   | `ctrl` + `b` then `ctrl` + `l`         |
  | kill pane / session (confirms)   | `ctrl` + `b` then `x` / `X`            |
  | copy mode: select / copy         | `v` / `y`                              |

  Each window keybind is bound under every name a terminal may send for it (`M-{`, `M-S-{`, `M-S-[`), with extended keys enabled for foot and ghostty.
  Pane moves are shared with Neovim through [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) (tmux plugin here, nvim plugin in kukenan): in an nvim pane they move between its splits first and cross into tmux at the edge. In other panes (Claude Code, fish) tmux takes `ctrl` + `h/j/k/l`.
