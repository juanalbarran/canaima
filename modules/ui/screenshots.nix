# ./modules/ui/screenshots.nix
{
  flake.modules.homeManager.ui = {
    lib,
    pkgs,
    ...
  }: let
    # screenshot full|area|clip: the whole output or a selected area to
    # ~/Pictures/screenshots, or a selected area to the clipboard
    screenshot = pkgs.writeShellApplication {
      name = "screenshot";
      runtimeInputs = with pkgs; [grim slurp wl-clipboard coreutils];
      text = ''
        dir="''${SCREENSHOTS_DIR:-$HOME/Pictures/screenshots}"
        file="$dir/screenshot-$(date +%Y-%m-%d-%H%M%S).png"
        # Esc in slurp cancels: nothing is taken
        area() { slurp || exit 0; }
        mkdir -p "$dir"
        case "''${1:-full}" in
          full) grim "$file" ;;
          area) grim -g "$(area)" "$file" ;;
          clip) grim -g "$(area)" - | wl-copy --type image/png ;;
          *)
            echo "usage: screenshot full|area|clip" >&2
            exit 1
            ;;
        esac
      '';
    };
    bind = mods: {
      inherit mods;
      key = "Print";
    };
  in {
    home.packages = [screenshot];
    ui.binds = {
      screenshotFull = {
        command = "${lib.getExe screenshot} full";
        bind = bind [];
      };
      screenshotArea = {
        command = "${lib.getExe screenshot} area";
        bind = bind ["shift"];
      };
      screenshotClip = {
        command = "${lib.getExe screenshot} clip";
        bind = bind ["ctrl"];
      };
    };
  };
}
