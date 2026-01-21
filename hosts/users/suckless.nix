# hosts/users/suckless.nix
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.juan = {
    isNormalUser = true;
    description = "Juan Jesus Albarran Rodriguez";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  home-manager.users.juan = import ./../../home/users/suckless;
  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;

    displayManager.ly = {
      enable = true;
      settings = {
        animation = "none";
        margin_box = "hcenter";
        big_clock = true;
      };
    };

    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
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
