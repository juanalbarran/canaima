# ./modules/gaming/steam.nix
{
  flake.modules.nixos.gaming = {pkgs, ...}: {
    # Steam with its FHS runtime, 32-bit graphics and controller udev rules
    programs.steam = {
      enable = true;
      # Stream games to/from other devices, and copy games over the LAN
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      # GE-Proton, pick it per game in Properties > Compatibility
      extraCompatPackages = [pkgs.proton-ge-bin];
      protontricks.enable = true;
    };
    # `gamemoderun %command%` in a game's launch options boosts the CPU while it runs
    programs.gamemode.enable = true;
  };
}
