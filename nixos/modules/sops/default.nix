# nixos/modules/sops/default.nix
{pkgs, ...}: {
  environment.packages = with pkgs; [
    sops
    age
    ssh-to-age
  ];
}
