# nixos/users/juan.nix
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.juan = {
    isNormalUser = true;
    description = "Juan Jesus Albarran Rodriguez";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
    ];
  };
  nix.settings.trusted-users = ["root" "juan"];
}
