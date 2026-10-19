# Browsers

One file per browser under `modules/browsers/`, merged into the `browsers` module. Imported by `canaima` and `mucuchies`. Themes come from sarisarinama (not yet).

- `qutebrowser`: the main browser (`ui.apps.browser`). Tabs on top, shown only with more than one. Adblock on, no autoplay. On `accounts.google.com` it sends a Chrome user agent, since Google refuses QtWebEngine logins. Quickmarks (`b` / `B` + name) and search engines (`o` + keyword): `nix`, `nixo` (NixOS options), `hm`, `g`; anything else goes to DuckDuckGo.

  | Action                | Keybind                              |
  | --------------------- | ------------------------------------ |
  | previous / next tab   | `alt` + `shift` + `[` / `]`          |
  | move tab left / right | `ctrl` + `alt` + `shift` + `[` / `]` |
  | open video in mpv     | `m` (hint) / `ctrl` + `m` (this tab) |
  | watch live stream     | `,t` (hint) / `,T` (this tab)        |
  | toggle page dark mode | `,d`                                 |

- `default-browser`: if the host sets `hostspec.defaultBrowser` (a desktop file name), `xdg-open` uses it for links and HTML files (`~/.config/mimeapps.list`). `asus` sets qutebrowser; `mucuchies` sets Chrome (`google-chrome.desktop`), as the laptop had. Also `about:` and unknown schemes. Other modules add their own handlers to the same `mimeapps.list` (`slack://`, magnet, `claude-cli://`), which Home Manager owns, so apps can't change it at runtime.
- `chrome`: Google Chrome (unfree), for sites that need it. Run-or-raise on `mod` + `g` (`ui.apps.chrome`, app_id `google-chrome`), always on workspace 4; qutebrowser stays `ui.apps.browser`. Flags for native Wayland and the GPU (rasterization, zero-copy, VA-API video, `--use-gl=egl` for Intel's EGL error).
- `brave`: Brave with Chrome's flags, the `Default` profile and one extension from the Chrome Web Store.
- `xremap`: Chrome can't rebind its tab keys, so [xremap](https://github.com/xremap/xremap) turns `alt` + `shift` + `[` / `]` into `ctrl` + (`shift` +) `tab` in Chrome only, the same keys as tmux, qutebrowser and Tridactyl. A user service that starts with the graphical session. Non-NixOS only: it needs to read `/dev/input` and write `/dev/uinput`, which on Ubuntu is the `input` and `uinput` groups and a udev rule (`KERNEL=="uinput", GROUP="uinput", MODE="0660"`); on NixOS that would need a NixOS-side half (`hardware.uinput`, groups), not written yet.
- `firefox/`: Firefox, one file per part.
  - `firefox`: the profile directory stays at `~/.mozilla/firefox`. Home Manager 26.05 defaults to `~/.config/mozilla/firefox`, but Firefox keeps using `~/.mozilla` while it exists, so the config would go where Firefox doesn't look. Native messaging for PWAs for Firefox and Tridactyl, whose `tridactylrc` binds `alt`/`ctrl` + `shift` + `[` / `]` to previous / next tab.
  - `profile`: the `default` profile: blank start page, bookmarks toolbar always shown, keyword bookmarks `nix` (NixOS packages) and `hm` (Home Manager options), YouTube and GitHub on the toolbar.
  - `policies`: no updates, studies, Pocket or telemetry; downloads to `~/Downloads`; no password saving (Proton Pass); strict tracking protection, locked.
  - `extensions`: installed by policy from addons.mozilla.org (uBlock Origin, NoScript, Privacy Badger, Proton Pass, Tridactyl, Tree Style Tab, Dark Reader, PWAs for Firefox…); Amazon, Bing, eBay and Google search are blocked.
  - `pwa`: [PWAs for Firefox](https://pwasforfirefox.filips.si/) (`firefoxpwa`), web apps like Gemini in their own window (`firefoxpwa site launch <id>`, app_id `FFPWA-<id>`). Each PWA profile is created at runtime with a random id, so an activation script hides their toolbar and tab bar instead of a declared profile.
