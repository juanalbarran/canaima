# hosts/users/suckless.nix
{
  config,
  pkgs,
  ...
}: {
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

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = ''
            ${pkgs.greetd.tuigreet}/bin/tuigreet \
              --time \
              --asterisks \
              --user-menu \
              --remember \
              --remember-session \
              --sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions \
              --cmd startx \
              --greeting "Welcome to NixOS"
          '';
          user = "greeter";
        };
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
