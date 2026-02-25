# nixos/modules/common/default.nix
{
  imports = [
    ./font.nix
    ./localization.nix
    ./networking.nix
    ./ui.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment = {
    variables = {
      EDITOR = "nvim-base";
      VISUAL = "nvim-base";
    };
  };
}
