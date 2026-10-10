# ./modules/media/mpv.nix
{
  flake.modules.homeManager.media = {
    config,
    lib,
    pkgs,
    ...
  }: {
    programs.yt-dlp.enable = true;
    programs.mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [mpris uosc thumbfast];
      config =
        {
          ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
          hwdec = "auto-safe";
          save-position-on-quit = true;
          # uosc draws its own controls and progress bar
          osc = false;
          osd-bar = false;
        }
        // lib.optionalAttrs (!config.hostspec.isNixOS) {
          # Nix apps on Ubuntu have no GPU drivers yet
          vo = "wlshm";
        };
      scriptOpts.ytdl_hook.ytdl_path = lib.getExe config.programs.yt-dlp.package;
    };
  };
}
