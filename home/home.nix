{ config, pkgs, ... }:

{
  imports = [
    ./modules/common.nix
  ];

  home = { 
    username = "juan";
    homeDirectory = "/home/juan";
    stateVersion = "25.05";
  };
}
