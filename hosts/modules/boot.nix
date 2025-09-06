# ./host/modules/boot.nix
{
  boot.loader = { 
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
