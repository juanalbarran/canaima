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

- `default-browser`: if the host sets `hostspec.defaultBrowser` (a desktop file name), `xdg-open` uses it for links and HTML files (`~/.config/mimeapps.list`). `asus` sets qutebrowser; `mucuchies` leaves it unset, so its own `mimeapps.list` stays.
- `chrome`: Google Chrome (unfree), for sites that need it. Not bound to a key; qutebrowser stays `ui.apps.browser`.
