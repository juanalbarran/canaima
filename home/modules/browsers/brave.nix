# home/modules/browsers/brave.nix
{pkgs, ...}: {
  programs.brave = {
    enable = true;
    package = pkgs.brave;

    commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--enable-features=UseOzonePlatform"

      # Default profile
      "--profile-directory=Default"

      # FORCE Hardware Acceleration
      "--ignore-gpu-blocklist"
      "--enable-gpu-rasterization"
      "--enable-zero-copy"

      # Video Decoding Flags
      "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder"
      "--disable-features=UseChromeOSDirectVideoDecoder"

      # Intel Specific Fix (Try to fix the EGL error)
      "--use-gl=egl"
    ];
    extensions = [
      {id = "hfjbmagddngcpeloejdejnfgbamkjaeg";}
    ];
  };
}
