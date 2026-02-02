# hosts/canaima/services.nix
{pkgs, ...}: {
  # List services that you want to enable:
  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;
    displayManager.ly.enable = true;
    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    # Dealing with laptop lid
    logind = {
      settings.Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchDocked = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        KillUserProcesses = false;
      };
    };
  };

  # Essential packages
  environment.systemPackages = with pkgs; [
    wget
    git
  ];
}
