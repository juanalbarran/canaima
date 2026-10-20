# UI

This document explains the ui guidelines for the ui

## Window Manager

For the window manager we will setup `Sway`, `Hyprland` and another one that we will decide later.
The window manager for the applications will follow the `run or raise` philosophy.

## Keybinds

`mod`: `alt`
`terminal` : `foot`
`aux terminal`: `ghostty`
`browser`: `qutebrowser`
`menu`: `quickshell made menu`
`ai`: `brave or any headless browser with gemini`
| Application | Keybind |
| ------------ | --------------------- |
| terminal | `mod` + `q` |
| aux terminal | `shift` + `mod` + `q` |
| browser | `mod` + `b` |
| chrome | `mod` + `g` |
| slack (mucuchies) | `mod` + `s` |
| ai | `mod` + `a` |
| menu | `mod` + `d` |
| projects | `mod` + `p` |
| close window | `mod` + `c` |
| reload WM and shell | `shift` + `mod` + `c` |
| projects at `~/nix/ctwo/ctwo-product` (mucuchies) | `shift` + `mod` + `p` |
| toggle passthrough | `ctrl` + `shift` + `mod` + `p` |
| lock screen | `ctrl` + `mod` + `q` |
| keybinds | `shift` + `mod` + `/` (`mod` + `?`) |
Keybinds come from semantic options in `modules/ui/wmspecs.nix`: `ui.apps` (run-or-raise apps, which have an `appId`), `ui.binds` (commands, e.g. the menu and the project menu at `~/dev`) and `ui.actions` (WM actions, e.g. `close`, `reload` and `passthrough`). Each WM translates them. Run-or-raise: the bind focuses the window with that `appId` if there is one, and otherwise launches `command`. terminal, auxTerminal and browser are set in `wmspecs.nix` as config with `mkDefault` on each field, not as the option's default, which would be dropped as soon as a feature module adds its own app (`browsers` adds chrome, `work` adds slack). An app bind replaces Sway's default on the same key: `mod` + `s` (stacking layout) is Slack's.

An app's `workspace` makes its windows always open there (Sway `assign`), wherever you launch them from; `null` (the default) opens them where you are. Run-or-raise takes you to the app's workspace: launching switches there first, and raising focuses the window, wherever it is. An `appId` must match the window's Wayland `app_id` exactly (case too, Slack's is `slack`), check it with `swaymsg -t get_tree`; with no match the bind only relaunches the app.

| App | Workspace |
| --- | --- |
| terminal | 1 |
| browser (qutebrowser) | 2 |
| chrome | 4 |
| slack (mucuchies) | 5 |

Passthrough is a WM mode whose only keybind is its own toggle, so every other key reaches the focused window. Games use it to bind `mod` combos, e.g. `alt` + `e` in WoW, which Sway's default keybinds would otherwise take.

`ui.startup` commands run once when the session starts. `ui.reload` commands run then and again on every WM reload (Sway's `exec_always`).

## Media keys

`modules/ui/media-keys.nix` adds `ui.binds` with no modifier for the laptop keys, on `canaima` and `mucuchies`. Volume with `wpctl` (PipeWire; the distro's on Ubuntu), stops at 100%; brightness with `brightnessctl`, which goes through logind, so no root or udev rule.

| Key | Action |
| --- | --- |
| volume up / down | ±5% |
| mute | toggle the speakers |
| mic mute | toggle the microphone |
| brightness up / down | ±10% |

## Screenshots

`modules/ui/screenshots.nix`, on `canaima` and `mucuchies`: a `screenshot` script (grim, slurp, wl-clipboard) and three `ui.binds`. Files go to `~/Pictures/screenshots/screenshot-<date>-<time>.png` (`SCREENSHOTS_DIR` overrides it). `Esc` while selecting an area cancels.

| Key | Action |
| --- | --- |
| `print` | whole screen → file |
| `shift` + `print` | selected area → file |
| `ctrl` + `print` | selected area → clipboard |

## Sway on another distro

`modules/ui/sway-generic-linux.nix` adds to the `sway` module when `hostspec.isNixOS` is false (`mucuchies`):

- Session: GDM lists only `/usr/share/wayland-sessions`, not `~/.local/share`, so Home Manager can't install it. The activation compares that file with the one it builds (`Exec=~/.nix-profile/bin/sway`) and, if it's missing or different, prints the `sudo install` command that copies it.
- Portals: Ubuntu's `xdg-desktop-portal` doesn't find Nix's backends, so the distro's are used (apt `xdg-desktop-portal-wlr`, `xdg-desktop-portal-gtk`). `~/.config/xdg-desktop-portal/sway-portals.conf` sends screen sharing and screenshots to `wlr` and the rest (file picker…) to `gtk`.

## Login

`modules/ui/login.nix` (NixOS only) runs greetd. If `hostspec.autologin` is set, the host boots straight into `ui.session.command` as that user, once. After logout, tuigreet asks for a password. `asus` sets `autologin = "juan"`.

## Shell

The ui shell is [sarisarinama](https://github.com/juanalbarran/sarisarinama), a flake input imported by `modules/ui/shell.nix` (`canaima` and `mucuchies`). The WM starts it through `ui.reload` with a script that kills the running instance first, so the reload keybind restarts the shell. `mod` + `d` toggles its menu over IPC.

The shell is also the lock screen: `ctrl` + `mod` + `q` locks over IPC (`ipc call lock lock`), and the shell itself locks on `loginctl lock-session`, after `programs.sarisarinama.lock.idle` seconds idle (default 300) and before suspend, so there is no swayidle. The password is checked against the PAM service `sarisarinama-lock`: on `asus` the `nixos` half of `shell` imports `modules.nixos.sarisarinama`, which declares it; on `mucuchies` Home Manager activation writes `/etc/pam.d/sarisarinama-lock` with sudo. Without the service the shell refuses to lock.

`mod` + `?` (`shift` + `mod` + `/`) opens the shell's keybinds menu: Neovim, Tmux and Sway, each opening a pane with that app's keybinds. The issue asked for `mod` + `k`, but that is Sway's focus up, so it stays. `modules/ui/keybinds.nix` fills the Sway section from `ui.apps`, `ui.binds` and Sway's final keybinding table (its defaults included, `mod` + `1`…`9` folded into one row), so it cannot disagree with what is bound. It also adds a `Canaima` group to the shell's tmux preset with what `modules/workspace/multiplexer.nix` binds; that one is written by hand, so a change there needs one here too.

`hostspec.panelFontSize` sets the font size in px of the menu and the network, monitor, VPN and keybinds panes (`style.<pane>.font.size`). `null` keeps the shell's own size. The bar always uses the shared `style.font.size` (12). `asus` sets 16 to match foot's `size=12`: foot uses points, the shell uses px, and 12 pt × 96/72 = 16 px.

## UI Suite

The ui suite will contain several applications made with `quickshell` to ensure consistency between the whole `ui`
The inspiration is the [omarchy](https://github.com/omacom/omarchy) menu and ui applications.
This will contain

- Menu
- Wifi / Network
- Sound
- VPN
- Battery
- Bar
- Clock
- Workspace management
- Bluetooth
- Theme selection
