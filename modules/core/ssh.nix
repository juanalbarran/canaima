# ./modules/core/ssh.nix
{
  flake.modules.nixos.core = {
    services.openssh.enable = true;
    programs.ssh.startAgent = true;
  };
}
