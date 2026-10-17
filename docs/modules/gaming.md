# Gaming

One file per feature under `modules/gaming/`, merged into the `gaming` module. NixOS only, imported by `canaima` (Steam needs the NixOS side for 32-bit graphics, udev rules and firewall ports, so `mucuchies` doesn't get it).

- `steam`: Steam with Remote Play and LAN game transfers open in the firewall, GE-Proton as an extra compatibility tool and protontricks. GameMode for `gamemoderun %command%` in a game's launch options.
