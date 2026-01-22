{
  config,
  pkgs,
  ...
}: {
  programs.gazelle = {
    enable = true;

    # Optional: Configure the look
    settings = {
      theme = "nord"; # Alternative option
      # theme = "tokyonight";
    };
  };

  # Ensure you are in the networkmanager group in your main configuration.nix!
}
