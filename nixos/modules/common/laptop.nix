# nixos/modules/common/laptop.nix
{
  services = {
    logind = {
      settings.Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchDocked = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        KillUserProcesses = false;
      };
    };
  };
}
