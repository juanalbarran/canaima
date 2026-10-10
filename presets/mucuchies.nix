# ./presets/mucuchies.nix
{
  config,
  inputs,
  ...
}: let
  home = config.flake.modules.homeManager;
in {
  flake.modules.homeManager.mucuchies = {
    imports = [
      home.core
      home.juan-albarran
      home.hostspec
      home.sway
      home.ui
      home.git
      home.ai
    ];
  };
  flake.homeConfigurations.mucuchies = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    extraSpecialArgs = {inherit inputs;};
    modules = [
      config.flake.modules.homeManager.mucuchies
      {
        hostspec = {
          hostname = "mucuchies";
          isNixOS = false;
          sshKeyName = "playa-el-yaque";
          emailSecret = "work/email";
        };
      }
    ];
  };
}
