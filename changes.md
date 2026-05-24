# CHANGES

Running log of the project state, recent work, and outstanding tasks. Updated at the end
of significant work sessions so future Claude Code sessions can pick up context quickly.

---

## Current state — 2026-05-24

### Machines

| Host           | Profile          | WM    | Last rebuild         | Status                        |
| -------------- | ---------------- | ----- | -------------------- | ----------------------------- |
| `canaima`      | `playa-el-agua`  | Sway  | 2026-05-22 ~21:30    | **Needs rebuild** (see below) |
| `sarisarinama` | `playa-caribe`   | Sway  | unknown              | unknown                       |
| `playa-el-yaque` (Ubuntu) | `playa-el-yaque` | Sway + Hyprland | 2026-05-24 | **Waybar workspace blank** (see below) |

### Waybar workspace bug — root cause identified (playa-el-yaque)

After rebuilding (`home-manager switch`) and restarting Sway, waybar still shows no
workspace indicator. Root cause: `playa-el-yaque` imports **both** `home/modules/ui/sway`
and `home/modules/ui/hyprland`. The Hyprland module unconditionally sets
`wayland.windowManager.hyprland.enable = true`. Every waybar component that reads
`config.wayland.windowManager.hyprland.enable` to detect the active WM sees `true`, so
waybar is configured to use `hyprland/workspaces` IPC — which has no socket when Sway
is running. Also affects `network` and `pulseaudio` terminal selection (baked to `kitty`
instead of `foot`).

**Fix implemented (not yet applied via home-manager):** Added `features.windowManager`
option to the waybar module. All implicit `wayland.windowManager.hyprland.enable` reads
replaced with `config.features.windowManager == "hyprland"` in workspaces, network, and
pulseaudio components. Both `playa-el-yaque` and `playa-el-agua` profiles set
`features.windowManager = "sway"` explicitly. Apply with:
```bash
home-manager switch --flake .#playa-el-yaque
```

### What's deployed vs what's in git

`canaima` was last rebuilt at ~21:30 on 2026-05-22. Several commits were made after that
point and have NOT been applied yet:

- **Sway config = null (deployed):** The `1a2a431 Sway` commit changed
  `wayland.windowManager.sway.config` from `{ extraConfig = ...; }` to `null`. The sway
  config is now managed exclusively via `xdg.configFile` entries. This is deployed.

- **Hyprland added to playa-el-yaque (not deployed on canaima):** The `3b9f174 Hyprland`
  commit added the Hyprland home module to `playa-el-yaque` and created a `.desktop` session
  file for non-NixOS installs.

- **Theme toggle fixes (not deployed):** `82a26b5 Themes` fixed browser theme toggling
  and added tmux theme support. Not yet applied on `canaima`.

### Immediate action needed

```bash
# 1. Apply features.windowManager fix (see above), then:
home-manager switch --flake .#playa-el-yaque   # fixes workspace indicator on Ubuntu

# 2. Once canaima is rebuilt:
sudo nixos-rebuild switch --flake .#canaima
```

---

## Recent significant changes (last 2 weeks)

### 2026-05-24

- **GDM sway session fix (playa-el-yaque):** Sway was not appearing in GDM despite the
  `.desktop` file being in `/usr/share/wayland-sessions/`. Root cause: that file was a
  symlink chain through `~/.local/share/` which has `drwx------` (700) permissions — the
  `gdm` user cannot traverse it, so GDM silently skips the session. Fix: replaced the
  broken symlink with an actual file:
  ```bash
  sudo tee /usr/share/wayland-sessions/sway.desktop << 'EOF'
  [Desktop Entry]
  Name=Sway
  Comment=An i3-compatible Wayland compositor
  Exec=/home/juan-albarran/.nix-profile/bin/sway
  Type=Application
  EOF
  ```
  This file is owned by root, not managed by HM, and survives future `home-manager switch`
  runs. Updated `SWAY.md` to document the correct approach (real file, not symlink).

### 2026-05-23
- **Documentation sprint:** Created `WAYBAR.md`, `SWAY.md`, `CHANGES.md`. Added pointers
  in `CLAUDE.md`. Fixed four issues in `CLAUDE.md`: removed `playa-el-agua` from standalone
  HM rebuild commands, fixed composition layers diagram, added `SWAY.md` pointer, added
  `gazelle` and `sfdx-nix` to Key inputs table (pending).
- **Sway → Nix install (done on playa-el-yaque):** `home/modules/ui/sway/default.nix` now
  sets `enable = true` and `package = pkgs.sway` unconditionally. A `.desktop` session file
  is generated at `~/.local/share/wayland-sessions/sway.desktop` on non-NixOS. Fixed
  `isNixOs` typo → `isNixOS`. Needed `lib.mkForce` on `xdg.configFile."sway/config"` in
  `configFiles/default.nix` to win over HM's auto-generated config (conflict when
  `enable = true`). Applied via `home-manager switch --flake .#playa-el-yaque`, apt sway
  removed. **Sway now runs from Nix on playa-el-yaque. ✓**

### 2026-05-22
- **`b3cae85` flake.nix:** Minor flake update.
- **`7b785dc` Themes:** Added `THEMES.md` documentation; fixed indentation in
  `toggle-theme.sh` (removed spurious leading spaces from `pkill -HUP foot`).
- **`1a2a431` Sway:** Cleaned up sway module — removed old `checkConfig = true` and
  switched to `config = null`. Removed stale commented-out `exec_always` line. Added
  `$grim` and `$slurp` variable definitions to `variables.conf`. Removed several
  `special-binds` files (`ai-binds`, `browser-binds`, `firefox-binds`; these still exist
  as conf files but the nix deployment was cleaned up).
- **`3b9f174` Hyprland:** Added Hyprland to `playa-el-yaque` profile. Added
  `xdg-desktop-portal-hyprland` to portals. Created `.desktop` session file for non-NixOS.

### 2026-05-21
- **`82a26b5` Themes:** Fixed theme toggle for Brave and Google Chrome (removed `--profile`
  flags that were breaking the commands). Added `exec_always` in sway autostart to load
  theme on Sway start. Added tmux theme template (`tmux.nix`). Fixed qutebrowser template
  variable naming.
- **`107938b` Firefox:** Firefox-related changes.

### 2026-05-20
- **`214015b` 1password:** 1Password integration changes.

### 2026-05-18
- **`1cbc87d` Sway:** Earlier Sway changes.
- **`7622f86` flake.lock, `3cc4f5a`–`3f315a4`** Work/Wireguard/Opencode/Projects updates.

---

## Outstanding issues

### Bugs

1. **Waybar workspace indicator blank** — fix implemented in git, needs `home-manager switch`
   on `playa-el-yaque` and `nixos-rebuild` on `canaima` to deploy.

2. ~~**`wayland.windowManager.sway.enable` not set**~~ — **Fixed.** `enable = true` and
   `package = pkgs.sway` added to `home/modules/ui/sway/default.nix`. Applied on
   `playa-el-yaque`.

3. **Waybar terminal mismatch** — `network` and `pulseaudio` waybar modules use `kitty`
   instead of `foot` because `isHyprland` is `true`. Will be fixed by the
   `features.windowManager` fix above.

### Technical debt

- Most app variables in `sway/configFiles/variables.conf` (`$browser`, `$ai`, `$slack`,
  `$chrome`) are hardcoded strings, not derived from `hostSpec`. See `sway.md` → Future
  Improvements.
- `wayland.windowManager.sway.enable` asymmetry with Hyprland (which does set it). See
  `sway.md` → Known Issues.
- Waybar WM detection relies on reading `wayland.windowManager.hyprland.enable` rather
  than an explicit `features.windowManager` option. See `waybar.md` → Future Improvements.

---

## Architecture snapshot

```
flake.nix
├── nixosConfigurations
│   ├── canaima     → hosts/canaima/  + budapest.nix  (HM: playa-el-agua)
│   └── sarisarinama → hosts/sarisarinama/ + caracas.nix (HM: playa-caribe)
└── homeConfigurations
    ├── playa-el-agua   → canaima personal (NixOS, Sway, foot, bemenu)
    └── playa-el-yaque  → work Ubuntu (standalone HM, Sway+Hyprland, foot, bemenu)
```

Key subsystems with their own documentation:
- Themes: `home/modules/ui/themes/themes.md`
- Wallpapers: `home/modules/ui/wallpapers/wallpapers.md`
- Scripts: `home/modules/scripts/scripts.md`
- Menus: `home/modules/menus/menus.md`
- Waybar: `home/modules/ui/waybar/waybar.md`
- Sway: `home/modules/ui/sway/sway.md`

---

## Future work (cross-cutting)

These are improvements that span multiple modules or don't fit cleanly in one `.md` file.

- **Rebuild `sarisarinama`** and verify `playa-caribe` profile is up to date.
- **`playa-el-yaque` first boot with Hyprland** — the Hyprland module was just added;
  needs testing on the Ubuntu laptop.
- **Unify terminal declaration** — `$term`/`$term_id` are in `hostSpec`, but waybar
  components and several binds still hardcode `foot`/`kitty`. A pass to use
  `config.hostSpec.terminal` everywhere would remove the duplication.
- **Swayidle / power management** — no idle timeout, screen dim, or suspend-on-lid is
  configured. Needs a `swayidle` home module.
- **Kanshi** — imported in `playa-el-agua` with a "do I really use this?" comment. Audit
  and either configure properly or remove.
