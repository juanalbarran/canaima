# home/modules/quickshell/default.nix
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.programs.canaima-quickshell;

  quickshellPkg = pkgs.quickshell;

  # Paths
  qmlPath = "${quickshellPkg}/lib/qt-6/qml:${pkgs.qt6.qtdeclarative}/lib/qt-6/qml";
  pluginPath = "${pkgs.qt6.qtwayland}/lib/qt-6/plugins:${pkgs.qt6.qtbase}/lib/qt-6/plugins";

  # Source Selection
  shellSource =
    if cfg.variant == "hyprland"
    then ./shell-hyprland.qml
    else if cfg.variant == "sway"
    then ./shell-sway.qml
    else ./shell.qml;

  wifiQml = pkgs.replaceVars ./components/common/Wifi.qml {
    nmcli = "${pkgs.networkmanager}/bin/nmcli";
    bash = "${pkgs.bash}/bin/bash";
  };

  # Bundling Step
  configDir = pkgs.runCommand "quickshell-config" {} ''
    mkdir -p $out
    cp ${shellSource} $out/shell.qml
    mkdir -p $out/components

    cp -r ${./components/common}/* $out/components/

    chmod -R u+w $out/components/

    cp -f ${wifiQml} $out/components/Wifi.qml

    ${
      if cfg.variant == "sway"
      then "cp -r ${./components/sway}/* $out/components/"
      else ""
    }
    ${
      if cfg.variant == "hyprland"
      then "cp -r ${./components/hyprland}/* $out/components/"
      else ""
    }
  '';

  runner =
    if cfg.withNixGL
    then "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${quickshellPkg}/bin/quickshell"
    else "${quickshellPkg}/bin/quickshell";

  quickshell-script = pkgs.writeShellScriptBin "quickshell" ''
    export QML_IMPORT_PATH="${qmlPath}"
    export QT_PLUGIN_PATH="${pluginPath}"
    export PATH="${pkgs.networkmanager}/bin:$PATH"

    # Required for Ubuntu/NixGL stability
    export QT_QPA_PLATFORM=wayland
    export EGL_PLATFORM=wayland
    unset QT_QPA_PLATFORMTHEME
    export QML_DISABLE_DISK_CACHE=1

    # Run exactly once. If it dies, it dies.
    exec ${runner} -p "${configDir}/shell.qml" "$@"
  '';
in {
  options.programs.canaima-quickshell = {
    enable = mkEnableOption "Enable customized Quickshell";
    variant = mkOption {
      type = types.enum ["hyprland" "sway" "default"];
      default = "default";
    };
    withNixGL = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [quickshell-script pkgs.nixgl.auto.nixGLDefault pkgs.qt6.qtwayland pkgs.qt6.qtbase];

    xdg.configFile."quickshell/shell.qml".source = shellSource;
    xdg.configFile."quickshell/components/Tray.qml".source = ./components/common/Tray.qml;
    xdg.configFile."quickshell/components/Clock.qml".source = ./components/common/Clock.qml;
    xdg.configFile."quickshell/components/Battery.qml".source = ./components/common/Battery.qml;
    xdg.configFile."quickshell/components/Wifi.qml".source = ./components/common/Wifi.qml;
  };
}
