# ./modules/core/laptop.nix
{
  flake.modules.nixos.core = {
    config,
    lib,
    ...
  }: {
    services.logind.settings.Login = lib.mkIf config.hostspec.isDocked {
      HandleLidSwitch = "ignore";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      KillUserProcesses = false;
    };
  };
}
