# Gazelle

Home Manager module for [Gazelle](https://github.com/Zeus-Deus/gazelle-tui), a terminal UI
for network management. Installed from a flake input; no configuration is needed beyond the
package itself.

## File Structure

```
home/modules/tui/gazelle/
└── default.nix   # Adds gazelle package from inputs.gazelle flake
```

## Installation

The package comes from the `gazelle` flake input (not nixpkgs):

```nix
inputs.gazelle.packages.${pkgs.stdenv.hostPlatform.system}.default
```

Used by: `playa-el-yaque`. Not imported on `playa-el-agua` or `playa-caribe`.

## How It Is Launched

Gazelle is opened as a floating foot terminal. Two entry points:

| Trigger                     | Command                                              |
| --------------------------- | ---------------------------------------------------- |
| `Mod+Shift+i` (Sway)        | `foot -a network sh -c ~/.nix-profile/bin/gazelle`   |
| Waybar network module click | `foot -a network -e ~/.nix-profile/bin/gazelle`      |

The `-a network` flag sets the `app_id` so the Sway window rule picks it up:

```
for_window [app_id="network"] {
  floating enable
  resize set 1000 800
  move position center
  border pixel 3
}
```

On Hyprland the waybar module uses `kitty --class network` instead of foot.

## Flake Input

Declared in `flake.nix`:

```nix
inputs = {
  gazelle.url = "github:Zeus-Deus/gazelle-tui";
};
```

## Future Improvements

- **Add to `playa-el-agua`:** Gazelle is currently only imported in `playa-el-yaque`.
  Adding it to the NixOS profile would give the same network TUI on the main machine.

- **Expose via `hostSpec`:** The gazelle binary path is hardcoded as
  `~/.nix-profile/bin/gazelle` in both the sway binding and the waybar component.
  A `hostSpec.networkManager` option (or deriving it from an installed package) would
  make the launch command consistent with how other apps are declared.

- **Sway run-or-raise:** The `Mod+Shift+i` binding always opens a new instance. A
  run-or-raise pattern (`swaymsg '[app_id="network"] focus' || exec ...`) would focus
  an existing gazelle window instead of spawning a second one.
