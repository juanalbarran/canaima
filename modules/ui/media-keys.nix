# ./modules/ui/media-keys.nix
{
  flake.modules.homeManager.ui = {
    lib,
    pkgs,
    ...
  }: let
    # wpctl talks to PipeWire, the distro's on Ubuntu; -l 1 stops at 100%
    wpctl = lib.getExe' pkgs.wireplumber "wpctl";
    # brightnessctl sets the backlight through logind, so it needs no root
    brightnessctl = lib.getExe pkgs.brightnessctl;
    key = k: {
      mods = [];
      key = k;
    };
  in {
    ui.binds = {
      volumeUp = {
        command = "${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
        bind = key "XF86AudioRaiseVolume";
      };
      volumeDown = {
        command = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        bind = key "XF86AudioLowerVolume";
      };
      volumeMute = {
        command = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
        bind = key "XF86AudioMute";
      };
      micMute = {
        command = "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        bind = key "XF86AudioMicMute";
      };
      brightnessUp = {
        command = "${brightnessctl} set 10%+";
        bind = key "XF86MonBrightnessUp";
      };
      brightnessDown = {
        command = "${brightnessctl} set 10%-";
        bind = key "XF86MonBrightnessDown";
      };
    };
  };
}
