# home/modules/core/default.nix
{
  imports = [
    ./packages.nix
    ./programs.nix
    ./gc
    ./ssh
    ./sops
    ./hostSpec
  ];
}
# This is the common modules in home manager the idea is that every single
# configuration will contain this.
# The modules containing this one should be usable for every configuration
# and should not be binded by any other, the only exception will be hostSpec
# that should be configured in the home-manager configuration. The reason of
# this is because hostSpec is a global variables configuration module.

