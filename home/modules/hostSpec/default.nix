# home/modules/hostSpec/default.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  options.hostSpec = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "The username of the host";
    };
    hostname = lib.mkOption {
      type = lib.type.str;
      description = "The hostname of the host";
    };
    email = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "The email of the user";
    };
  };
}
