# ./modules/meta/specs.nix
{lib, ...}: let
  hostspec = {
    options.hostspec = {
      hostname = lib.mkOption {
        type = lib.types.str;
        description = "The machine's hostname";
      };
      isDocked = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Laptop used docked with the lid closed";
      };
      stateVersion = lib.mkOption {
        type = lib.types.str;
        default = "26.05";
        description = "State version for both nixos and home-manager";
      };
      isNixOS = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Indicates if the OS is NixOS or any other distribution";
      };
      autologin = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "User logged in automatically once at boot; null disables it";
      };
      sshKeyName = lib.mkOption {
        type = lib.types.str;
        description = "Name of the SSH key in sops (private_keys/<name>), deployed to ~/.ssh/<name>";
      };
      emailSecret = lib.mkOption {
        type = lib.types.str;
        description = "Sops secret holding the git email, e.g. personal/email";
      };
      defaultBrowser = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "org.qutebrowser.qutebrowser.desktop";
        description = "Desktop file xdg-open uses for links and HTML; null leaves mimeapps.list alone";
      };
      shell = lib.mkOption {
        type = lib.types.enum ["fish" "bash"];
        default = "fish";
        description = "Interactive shell that foot and tmux start; bash stays the login shell either way";
      };
      githubUser = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "GitHub account gh logs in as, with the sops token; null leaves gh unmanaged";
      };
      panelFontSize = lib.mkOption {
        type = lib.types.nullOr lib.types.ints.positive;
        default = null;
        example = 16;
        description = "Font size in px for the shell menu and panes; null keeps the shell's own size";
      };
    };
  };
in {
  flake.modules.nixos.hostspec = hostspec;
  flake.modules.homeManager.hostspec = hostspec;
}
