# home/modules/fastfetch/default.nix
{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      fastfetch
    ];
    file = {
      ".config/fastfetch/config.jsonc".source = ./config.jsonc;
      "Pictures/jacko" = {
        source = ../../assets/jacko;
        recursive = true;
      };
    };
  };
}
