# ./modules/ui/login.nix
{
  flake.modules.nixos.login = {
    config,
    lib,
    pkgs,
    ...
  }: let
    session = config.ui.session.command;
    # The session files programs.sway and programs.hyprland register, so F3
    # in tuigreet picks the WM. --cmd is the pick until one is remembered.
    # Without Hyprland's uwsm one: this config doesn't start it through uwsm
    sessions = pkgs.runCommand "wayland-sessions" {} ''
      mkdir $out
      cp ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions/*.desktop $out/
      rm -f $out/*-uwsm.desktop
    '';
  in {
    services.greetd = {
      enable = true;
      # Keeps boot messages from drawing over tuigreet
      useTextGreeter = true;
      settings = {
        default_session.command = "${lib.getExe pkgs.tuigreet} --time --remember --remember-user-session --sessions ${sessions} --cmd ${session}";
        initial_session = lib.mkIf (config.hostspec.autologin != null) {
          command = session;
          user = config.hostspec.autologin;
        };
      };
    };
  };
}
