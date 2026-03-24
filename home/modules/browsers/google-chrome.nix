# home/modules/browsers/google-chrome.nix
{
  programs.google-chrome = {
    enable = true;

    # You can reuse the same Wayland/GPU flags you used for Brave
    commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--enable-features=UseOzonePlatform"
      "--ignore-gpu-blocklist"
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
      "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder"
      "--disable-features=UseChromeOSDirectVideoDecoder"
      "--use-gl=egl"
    ];
  };
}
