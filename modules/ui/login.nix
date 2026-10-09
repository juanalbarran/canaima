# ./modules/ui/login.nix
{
  flake.modules.nixos.login = {
    config,
    lib,
    pkgs,
    ...
  }: let
    session = config.ui.session.command;
  in {
    services.greetd = {
      enable = true;
      settings = {
        default_session.command = "${lib.getExe pkgs.tuigreet} --time --remember --cmd ${session}";
        initial_session = lib.mkIf (config.hostspec.autologin != null) {
          command = session;
          user = config.hostspec.autologin;
        };
      };
    };
  };
}
