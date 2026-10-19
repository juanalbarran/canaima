# ./modules/browsers/chrome.nix
{
  flake.modules.homeManager.browsers = {
    programs.google-chrome = {
      enable = true;
      # Native Wayland, and the GPU for drawing and video even when Chrome's
      # blocklist says no; --use-gl=egl fixes the EGL error on Intel
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--ignore-gpu-blocklist"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
        "--enable-features=UseOzonePlatform,VaapiVideoDecoder,VaapiVideoEncoder"
        "--disable-features=UseChromeOSDirectVideoDecoder"
        "--use-gl=egl"
      ];
    };
    ui.apps.chrome = {
      command = "google-chrome-stable";
      appId = "google-chrome";
      workspace = 4;
      bind.key = "g";
    };
  };
}
