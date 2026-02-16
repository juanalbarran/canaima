# nixos/modules/common/default.nix
{pkgs, ...}: {
  imports = [
    ./font.nix
    ./localization.nix
    ./networking.nix
    ./ui.nix
    ./gc.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment = {
    systemPackages = with pkgs; [
      wl-clipboard
    ];
    variables = {
      EDITOR = "nvim-base";
      VISUAL = "nvim-base";
    };
  };
}
