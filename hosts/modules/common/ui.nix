# hosts/modules/common/ui.nix
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Necessary for many 32-bit compatibility layers
  };
}
