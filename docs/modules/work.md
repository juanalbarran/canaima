# Work

One file per app under `modules/work/`, merged into the `work` module. Imported by `mucuchies` only, it's what the work laptop needs on top of `workspace`.

- `slack`: Slack, run-or-raise on `mod` + `s` (`ui.apps.slack`, app_id `Slack`), always on workspace 5. It replaces Sway's default `mod` + `s` (stacking layout).
- `1password`: the 1Password app and its CLI (`op`).
- `wireguard`: `wireguard-tools`, and `~/.config/wireguard/wg0.conf` as a sops template: the private and preshared keys come from `access_tokens/wireguard/*`. Bring it up by hand with `sudo wg-quick up ~/.config/wireguard/wg0.conf`.
- `drata`: Drata's compliance agent, wrapped from its AppImage (`_drata-agent.nix`, skipped by `import-tree`). It downloads the `latest` release, so when Drata publishes a new one the hash breaks and has to be updated.
- `openvpn`: the `openvpn` CLI and the `vpn/nix` secret at `~/.config/openvpn/nix.conf`. Ubuntu's NetworkManager uses its own OpenVPN plugin (apt), and the shell's VPN pane turns connections on and off through `nmcli`, so there's no Nix plugin.
  - Connections the pane can toggle: `wg0` (WireGuard, keys stored in NetworkManager, nothing else needed) and `nxvpn-ng` (OpenVPN, `password-tls`). `nxvpn-ng`'s password belongs to a secret agent (`password-flags=1`), and `nmcli` from the pane can't prompt, so sway starts `nm-applet --indicator` as that agent: it takes the password from gnome-keyring, or asks in a dialog (tick save to keep it in the keyring).
  - NetworkManager's `wg0` is a copy imported once; `~/.config/wireguard/wg0.conf` from sops is the source to re-import from (`nmcli connection import type wireguard file ~/.config/wireguard/wg0.conf`) if the keys change.
- `projects`: the shell's projects menu rooted at `~/nix/ctwo/ctwo-product` (the CTWO repos) on `mod` + `shift` + `p`, next to `mod` + `p` for `~/dev`. Needs the shell module. Unlike main's menu, it lists the repos under the root but not `ctwo-product` itself.
- `path`: `~/.local/bin` and `~/.ctwo/bin` on `PATH`, for bash and fish. `~/.ctwo/bin` goes first, after genericLinux's `nix.sh` (which puts `~/.nix-profile/bin` in front), because CTWO's `claude` shim there has to shadow the real `claude`: it prints the CTWO banner and then runs it. genericLinux sources `nix.sh` a second time in `.bashrc`, so `.bashrc` also moves `~/.ctwo/bin` back to the front at its end (dropping the old entry, so nested shells don't repeat it).
