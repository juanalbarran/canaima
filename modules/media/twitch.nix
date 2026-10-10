# ./modules/media/twitch.nix
{
  flake.modules.homeManager.media = {
    config,
    lib,
    pkgs,
    ...
  }: {
    programs.streamlink = {
      enable = true;
      settings = {
        player = lib.getExe config.programs.mpv.finalPackage;
        default-stream = "1080p60,1080p,best";
        twitch-low-latency = true;
      };
    };
    home.packages = [pkgs.chatterino2];
  };
}
