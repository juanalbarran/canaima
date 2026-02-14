{
  nix = {
    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 30d";
    };
    settings.auto-optimise-store = true;
  };
}
