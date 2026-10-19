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
| toggle passthrough | `shift` + `mod` + `p` |
Keybinds come from semantic options in `modules/ui/wmspecs.nix`: `ui.apps` (run-or-raise apps, which have an `appId`), `ui.binds` (commands, e.g. the menu and the project menu at `~/dev`) and `ui.actions` (WM actions, e.g. `close`, `reload` and `passthrough`). Each WM translates them. Run-or-raise: the bind focuses the window with that `appId` if there is one, and otherwise launches `command`. terminal, auxTerminal and browser are set in `wmspecs.nix` as config with `mkDefault` on each field, not as the option's default, which would be dropped as soon as a feature module adds its own app (`browsers` adds chrome, `work` adds slack). An app bind replaces Sway's default on the same key: `mod` + `s` (stacking layout) is Slack's.

An app's `workspace` makes its windows always open there (Sway `assign`), wherever you launch them from; `null` (the default) opens them where you are. Focus doesn't follow a window assigned elsewhere, but run-or-raise brings you to it on the next press.

| App | Workspace |
| --- | --- |
| terminal | 1 |
| browser (qutebrowser) | 2 |
| chrome | 4 |
| slack (mucuchies) | 5 |

Passthrough is a WM mode whose only keybind is its own toggle, so every other key reaches the focused window. Games use it to bind `mod` combos, e.g. `alt` + `e` in WoW, which Sway's default keybinds would otherwise take.

`ui.startup` commands run once when the session starts. `ui.reload` commands run then and again on every WM reload (Sway's `exec_always`).

## Sway on another distro

`modules/ui/sway-generic-linux.nix` adds to the `sway` module when `hostspec.isNixOS` is false (`mucuchies`):

- Session: GDM lists only `/usr/share/wayland-sessions`, not `~/.local/share`, so Home Manager can't install it. The activation compares that file with the one it builds (`Exec=~/.nix-profile/bin/sway`) and, if it's missing or different, prints the `sudo install` command that copies it.
- Portals: Ubuntu's `xdg-desktop-portal` doesn't find Nix's backends, so the distro's are used (apt `xdg-desktop-portal-wlr`, `xdg-desktop-portal-gtk`). `~/.config/xdg-desktop-portal/sway-portals.conf` sends screen sharing and screenshots to `wlr` and the rest (file picker…) to `gtk`.

## Login

`modules/ui/login.nix` (NixOS only) runs greetd. If `hostspec.autologin` is set, the host boots straight into `ui.session.command` as that user, once. After logout, tuigreet asks for a password. `asus` sets `autologin = "juan"`.

## Shell

The ui shell is [sarisarinama](https://github.com/juanalbarran/sarisarinama), a flake input imported by `modules/ui/shell.nix` (`canaima` and `mucuchies`). The WM starts it through `ui.reload` with a script that kills the running instance first, so the reload keybind restarts the shell. `mod` + `d` toggles its menu over IPC.

`hostspec.panelFontSize` sets the font size in px of the menu and the network, monitor and VPN panes (`style.<pane>.font.size`). `null` keeps the shell's own size. The bar always uses the shared `style.font.size` (12). `asus` sets 16 to match foot's `size=12`: foot uses points, the shell uses px, and 12 pt × 96/72 = 16 px.

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
