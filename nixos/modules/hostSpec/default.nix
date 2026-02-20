# nixos/modules/hostSpec/default.nix
{lib, ...}: {
  options.hostSpec = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "The username of the host";
    };
    hostname = lib.mkOption {
      type = lib.types.str;
      description = "The hostname of the host";
    };
    email = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "The email of the user"};
    };
    sshKeyName = lib.mkOption {
      type = lib.types.str;
      description = "The name of the ssh keys of the user";
    };
  };
}
