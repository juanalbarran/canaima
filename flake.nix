# flake.nix
{
  description = "Canaima NixOS configuration with Home Manager";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    kukenan.url = "github:juanalbarran/neovim/main";
    gazelle.url = "github:Zeus-Deus/gazelle-tui";
    sfdx-nix.url = "github:rfaulhaber/sfdx-nix";
    nix-claude-code.url = "github:ryoppippi/nix-claude-code";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
      url = "git+ssh://git@github.com/juanalbarran/fortin-de-la-galera.git";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      canaima = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs system pkgs-unstable;
        };
        modules = [
          {
            nixpkgs.hostPlatform = system;
            nixpkgs.config.allowUnfree = true;
          }
          ./hosts/canaima
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit inputs system pkgs-unstable;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
      sarisarinama = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs system pkgs-unstable;
        };
        modules = [
          {
            nixpkgs.hostPlatform = system;
            nixpkgs.config.allowUnfree = true;
          }
          ./hosts/sarisarinama
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit inputs system pkgs-unstable;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
    };
    homeConfigurations = {
      "playa-el-agua" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./configuration/home-configuration/playa-el-agua];
        extraSpecialArgs = {
          inherit inputs system pkgs-unstable;
        };
      };
      "playa-el-yaque" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./configuration/home-configuration/playa-el-yaque];
        extraSpecialArgs = {
          inherit inputs system pkgs-unstable;
        };
      };
    };
  };
}
