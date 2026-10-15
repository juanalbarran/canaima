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
| ai | `mod` + `a` |
| menu | `mod` + `d` |
| projects | `mod` + `p` |
| close window | `mod` + `c` |
Keybinds come from semantic options in `modules/ui/wmspecs.nix`: `ui.apps` (run-or-raise apps, which have an `appId`), `ui.binds` (commands, e.g. the menu and the project menu at `~/dev`) and `ui.actions` (WM actions, e.g. `close`). Each WM translates them.

## Login

`modules/ui/login.nix` (NixOS only) runs greetd. If `hostspec.autologin` is set, the host boots straight into `ui.session.command` as that user, once. After logout, tuigreet asks for a password. `asus` sets `autologin = "juan"`.

## Shell

The ui shell is [sarisarinama](https://github.com/juanalbarran/sarisarinama), a flake input imported by `modules/ui/shell.nix` (`canaima` only for now). The WM starts it through `ui.startup`, and `mod` + `d` toggles its menu over IPC.

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
