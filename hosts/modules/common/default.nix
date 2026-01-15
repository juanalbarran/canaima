# hosts/modules/common/default.nix
{
  imports = [
    ./font
    ./boot.nix
    ./localization.nix
    ./networking.nix
    ./ui.nix
  ];
}
