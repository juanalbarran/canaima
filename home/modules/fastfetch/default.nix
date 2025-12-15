# home/modules/fastfetch/default.nix
{
  home.file = {
    ".config/fastfetch/config.jsonc".source = ./config.jsonc;
    "Pictures/jacko" = {
      source = ../../assets/jacko;
      recursive = true;
    };
  };
}
