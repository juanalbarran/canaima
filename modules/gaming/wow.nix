# ./modules/gaming/wow.nix
{
  flake.modules.nixos.gaming = {
    config,
    pkgs,
    ...
  }: let
    # 32 and 64-bit Wine, staging patches help older DirectX games
    wine = pkgs.wineWow64Packages.stagingFull;
    # Whitemane's official launcher is an unversioned AppImage that patches the client itself,
    # so it is fetched on first run instead of pinned with a hash that breaks on every release
    whitemane = pkgs.writeShellApplication {
      name = "whitemane";
      runtimeInputs = [pkgs.curl config.programs.appimage.package wine];
      text = ''
        dir="''${WHITEMANE_DIR:-$HOME/Games/whitemane}"
        appimage="$dir/Whitemane.AppImage"
        if [ ! -f "$appimage" ]; then
          mkdir -p "$dir"
          curl -fSL --progress-bar -o "$appimage" \
            https://launcher.gamefreedom.org/artifacts/whitemane/Whitemane.AppImage
          chmod +x "$appimage"
        fi
        # umu-run uses the GE-Proton Steam already has instead of downloading it from GitHub
        export PROTONPATH="''${PROTONPATH:-${pkgs.proton-ge-bin.steamcompattool}}"
        # Steam's mirrors disagree on the latest runtime, so umu-run redownloaded ~200 MB
        # on every launch and the client hung on "Initializing environment"
        export UMU_RUNTIME_UPDATE="''${UMU_RUNTIME_UPDATE:-0}"
        exec appimage-run "$appimage" "$@"
      '';
    };
  in {
    # Runs AppImages in an FHS environment, binfmt lets them start like normal binaries
    programs.appimage = {
      enable = true;
      binfmt = true;
      # The launcher is a Tauri app, these are the libraries its binary links (readelf -d),
      # glib-networking for HTTPS, Wine for the launcher-game.exe it bundles, and umu-launcher,
      # which the launcher uses to run the client with Proton
      package = pkgs.appimage-run.override {
        extraPkgs = p: [
          p.webkitgtk_4_1
          p.libsoup_3
          p.gtk3
          p.glib
          p.glib-networking
          p.gdk-pixbuf
          p.cairo
          p.dbus
          p.libayatana-appindicator
          wine
          p.umu-launcher
        ];
      };
    };
    environment.systemPackages = [
      wine
      pkgs.winetricks
      pkgs.umu-launcher
      whitemane
      (pkgs.makeDesktopItem {
        name = "whitemane";
        desktopName = "WoW Whitemane";
        comment = "Whitemane launcher, World of Warcraft private server (Frozen Throne realm)";
        exec = "whitemane";
        icon = "wine";
        categories = ["Game"];
      })
      # Installs Battle.net for retail World of Warcraft (WoW forever) from Lutris' own install script
      pkgs.lutris
    ];
  };
}
