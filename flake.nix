# flake.nix
{
  description = "Canaima NixOS configuration with Home Manager";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    kukenan.url = "github:juanalbarran/neovim/main";
    gazelle.url = "github:Zeus-Deus/gazelle-tui";
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
    kukenan,
    gazelle,
    sops-nix,
    secrets,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    pkgs-unstable = import nixpkgs-unstable {
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
          inherit inputs kukenan system pkgs-unstable secrets;
        };
        modules = [
          {nixpkgs.hostPlatform = system;}
          ./hosts/canaima
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          {
            home-manager.extraSpecialArgs = {
              inherit inputs secrets kukenan system pkgs-unstable sops-nix;
            };
          }
        ];
      };
      sarisarinama = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit kukenan system pkgs-unstable;
        };
        modules = [
          {nixpkgs.hostPlatform = system;}
          ./hosts/sarisarinama
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit kukenan system gazelle pkgs-unstable;
            };
          }
        ];
      };
    };
    homeConfigurations = {
      "playa-el-agua" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./configuration/home-configuration/playa-el-agua];
        extraSpecialArgs = {
          inherit kukenan system gazelle pkgs-unstable sops-nix secrets;
        };
      };
      "playa-el-yaque" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./configuration/home-configuration/playa-el-yaque];
        extraSpecialArgs = {
          inherit inputs kukenan system gazelle pkgs-unstable sops-nix secrets;
        };
      };
    };
  };
}
