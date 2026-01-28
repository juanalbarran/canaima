# flake.nix
{
  description = "Canaima NixOS configuration with Home Manager";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kukenan = {
      url = "github:juanalbarran/neovim/kick";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gazelle = {
      url = "github:Zeus-Deus/gazelle-tui";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    kukenan,
    gazelle,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    devShells.${system}.suckless = pkgs.mkShell {
      # toolchain + headers/libs
      packages = with pkgs; [
        pkg-config
        xorg.libX11
        xorg.libXft
        xorg.libXinerama
        fontconfig
        freetype
        harfbuzz
        gcc
        gnumake
      ];
    };
    nixosConfigurations = {
      canaima = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit kukenan system;
        };
        modules = [
          {nixpkgs.hostPlatform = system;}
          ./hosts/configurations/canaima
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit kukenan system;
            };
          }
        ];
      };
      suckless = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit kukenan system;
        };
        modules = [
          {nixpkgs.hostPlatform = system;}
          ./hosts/configurations/suckless
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit kukenan system gazelle;
            };
          }
        ];
      };
    };
    homeConfigurations = {
      "juan" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home/users/juan];
        extraSpecialArgs = {
          inherit kukenan system gazelle;
        };
      };
      "nix" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home/users/nix];
        extraSpecialArgs = {
          inherit kukenan system gazelle;
        };
      };
    };
  };
}
