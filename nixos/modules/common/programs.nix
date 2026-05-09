{pkgs, ...}: {
  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      xorg.libX11
      xorg.libXext
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
      xorg.libXinerama
      libGL
      alsa-lib
      libpulseaudio
    ];
  };
}
