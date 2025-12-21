# home/modules/quickshell/default.nix
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.programs.canaima-quickshell;

  # Paths
  qmlPath = "${pkgs.quickshell}/lib/qt-6/qml:${pkgs.qt6.qtdeclarative}/lib/qt-6/qml";
  pluginPath = "${pkgs.qt6.qtwayland}/lib/qt-6/plugins:${pkgs.qt6.qtbase}/lib/qt-6/plugins";

  # Runner Logic (NixGL vs Raw)
  runner =
    if cfg.withNixGL
    then "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${pkgs.quickshell}/bin/quickshell"
    else "${pkgs.quickshell}/bin/quickshell";

  # Wrapper Script
  quickshell-script = pkgs.writeShellScriptBin "quickshell" ''
    export QML_IMPORT_PATH="${qmlPath}"
    export QT_PLUGIN_PATH="${pluginPath}"
    export QT_QPA_PLATFORM=wayland
    exec ${runner} "$@"
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
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [quickshell-script pkgs.qt6.qtwayland pkgs.qt6.qtbase];

    xdg.configFile."quickshell/shell.qml".source =
      if cfg.variant == "hyprland"
      then ./shell-hyprland.qml
      else if cfg.variant == "sway"
      then ./shell-sway.qml
      else ./shell.qml;
  };
}
