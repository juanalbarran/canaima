# Work

One file per app under `modules/work/`, merged into the `work` module. Imported by `mucuchies` only, it's what the work laptop needs on top of `workspace`.

- `slack`: Slack.
- `1password`: the 1Password app and its CLI (`op`).
- `wireguard`: `wireguard-tools`, and `~/.config/wireguard/wg0.conf` as a sops template: the private and preshared keys come from `access_tokens/wireguard/*`. Bring it up by hand with `sudo wg-quick up ~/.config/wireguard/wg0.conf`.
- `drata`: Drata's compliance agent, wrapped from its AppImage (`_drata-agent.nix`, skipped by `import-tree`). It downloads the `latest` release, so when Drata publishes a new one the hash breaks and has to be updated.
- `path`: `~/.ctwo/bin` (CTWO's CLI tools) and `~/.local/bin` on `PATH`, for bash and fish.
