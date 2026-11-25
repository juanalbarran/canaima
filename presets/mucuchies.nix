# ./presets/mucuchies.nix
{
  config,
  inputs,
  ...
}: let
  home = config.flake.modules.homeManager;
in {
  flake.modules.homeManager.mucuchies = {
    imports = with home; [
      core
      juan-albarran
      hostspec
      sway
      hyprland
      ui
      shell
      ai
      workspace
      browsers
      media
      gaming
      work
    ];
  };
  flake.homeConfigurations.mucuchies = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
      # qutebrowser 3.7.0 still accepts eMudhra TLS certs; nixpkgs has no newer release yet
      config.permittedInsecurePackages = ["qutebrowser-3.7.0"];
    };
    extraSpecialArgs = {inherit inputs;};
    modules = [
      config.flake.modules.homeManager.mucuchies
      {
        hostspec = {
          hostname = "mucuchies";
          isNixOS = false;
          sshKeyName = "playa-el-yaque";
          emailSecret = "work/email";
          defaultBrowser = "google-chrome.desktop";
          panelFontSize = 16;
          shell = "bash";
          projectsRoot = "~/dev";
          workProjectsRoot = "~/nix/nix";
        };
      }
    ];
  };
}
