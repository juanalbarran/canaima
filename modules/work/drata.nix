# ./modules/work/drata.nix
{
  flake.modules.homeManager.work = {pkgs, ...}: {
    # Compliance agent the company requires on the laptop
    home.packages = [(pkgs.callPackage ./_drata-agent.nix {})];
  };
}
