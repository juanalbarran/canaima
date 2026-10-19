# Media

One file per feature under `modules/media/`, merged into the `media` module. Imported by `canaima` and `mucuchies`; `browsers` uses it for its mpv and streamlink binds.

- `mpv`: mpv with uosc (controls), thumbfast (seek previews) and mpris (media keys), yt-dlp as its backend, 1080p max, resumes where you stopped. CPU output (`vo=wlshm`) on non-NixOS.
- `twitch`: streamlink plays live streams in that mpv, low latency, ads skipped; chatterino2 for the chat.
- `qbittorrent`: qBittorrent, the torrent client.
