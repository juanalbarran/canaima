# home/modules/games/gpu-32.nix
# 32-bit counterpart of Home Manager's targets.genericLinux.gpu (non-NixOS only).
# HM links 64-bit drivers to /run/opengl-driver; 32-bit Windows programs
# (e.g. Battle.net-Setup.exe) look for theirs in /run/opengl-driver-32.
{
  config,
  lib,
  pkgs,
  ...
}: let
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

  # Run once with sudo (and again after driver updates): installs the unit
  # and registers a gcroot so the drivers aren't garbage-collected.
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
  lib.mkIf (!config.hostSpec.isNixOS) {
    home.packages = [setup];

    home.activation.checkGpuDrivers32 = lib.hm.dag.entryAnywhere ''
      if [[ "$(readlink /run/opengl-driver-32 || true)" != "${drivers}" ]]; then
        warnEcho "32-bit GPU drivers are missing or outdated, run"
        warnEcho "  sudo ${lib.getExe setup}"
      fi
    '';
  }
