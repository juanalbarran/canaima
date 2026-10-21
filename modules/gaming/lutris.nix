# ./modules/gaming/lutris.nix
{
  flake.modules.homeManager.gaming = {
    config,
    lib,
    pkgs,
    ...
  }: let
    # 32-bit counterpart of Home Manager's targets.genericLinux.gpu, which only links the 64-bit
    # drivers to /run/opengl-driver. 32-bit Windows programs (Battle.net-Setup.exe) look for
    # theirs in /run/opengl-driver-32, and without them DXVK fails to create a Vulkan instance
    drivers = pkgs.pkgsi686Linux.mesa;
    unit = pkgs.writeText "non-nixos-gpu-32.service" ''
      [Unit]
      Description=32-bit GPU driver setup for Nix on non-NixOS Linux systems

      [Install]
      WantedBy=multi-user.target

      [Service]
      Type=oneshot
      ExecStart=ln -nsf ${drivers} /run/opengl-driver-32
      RemainAfterExit=yes
    '';
    # Run once with sudo, and again after driver updates: installs the unit and registers
    # a gcroot so the drivers aren't garbage-collected
    setup = pkgs.writeShellScriptBin "non-nixos-gpu-32-setup" ''
      set -e
      unit_path=/etc/systemd/system/non-nixos-gpu-32.service
      ln -sf ${unit} "$unit_path"
      ln -sf "$unit_path" /nix/var/nix/gcroots/non-nixos-gpu-32.service
      systemctl daemon-reload
      systemctl enable non-nixos-gpu-32.service
      systemctl restart non-nixos-gpu-32.service
    '';
  in
    lib.mkMerge [
      {
        # Installs Battle.net for retail World of Warcraft (WoW forever) through its own
        # Wine/DXVK runners. The package is an FHS sandbox, so the downloaded Windows binaries
        # find the libraries they expect. Games and the library live in ~/Games and
        # ~/.local/share/lutris, outside the store, so they survive reinstalls
        home.packages = [pkgs.lutris];
      }
      (lib.mkIf (!config.hostspec.isNixOS) {
        home.packages = [setup];
        home.activation.checkGpuDrivers32 = lib.hm.dag.entryAnywhere ''
          if [[ "$(readlink /run/opengl-driver-32 || true)" != "${drivers}" ]]; then
            warnEcho "32-bit GPU drivers are missing or outdated, run"
            warnEcho "  sudo ${lib.getExe setup}"
          fi
        '';
      })
    ];
}
