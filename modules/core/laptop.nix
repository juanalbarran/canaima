# ./modules/core/laptop.nix
{
  flake.modules.nixos.core = {
    config,
    lib,
    ...
  }: {
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;

    services.logind.settings.Login = lib.mkIf config.hostspec.isDocked {
      HandleLidSwitch = "ignore";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      KillUserProcesses = false;
    };
  };
}
