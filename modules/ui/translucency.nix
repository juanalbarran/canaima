# ./modules/ui/translucency.nix
# Only when Hyprland is the WM: the terminals' background and every surface
# of the shell are see-through, by hostspec.opacity, and Hyprland blurs what
# shows through them. Under Sway all of them stay opaque. The shell's half,
# its hyprlandOpacity, is in shell.nix, which owns its config
{
  flake.modules.homeManager.hyprland = {
    config,
    lib,
    pkgs,
    ...
  }: let
    alpha = toString config.hostspec.opacity;
    # The shell's layers with a translucent card; not the wallpaper, nor the
    # image viewer, whose backdrop has its own alpha
    layers = "^(sarisarinama-(bar|menu|notifications|notifications-panel|network|monitor|vpn|battery|audio|bluetooth|keybinds))$";
    # Each terminal reads one config under both WMs, so the alpha goes on its
    # command line, and only when Hyprland started it: HYPRLAND_INSTANCE_SIGNATURE,
    # the variable the shell checks too. Every launcher (binds, run-or-raise,
    # the project menu) runs the terminal from PATH, so all of them get it
    onHyprland = pkg: flags:
      pkgs.symlinkJoin {
        name = "${pkg.pname}-translucent";
        meta.mainProgram = pkg.meta.mainProgram;
        paths = [pkg];
        postBuild = ''
          bin=$out/bin/${pkg.meta.mainProgram}
          rm "$bin"
          cat > "$bin" <<EOF
          #!${pkgs.runtimeShell}
          if [ -n "\''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
            exec ${lib.getExe pkg} ${flags} "\$@"
          fi
          exec ${lib.getExe pkg} "\$@"
          EOF
          chmod +x "$bin"
        '';
      };
  in {
    # matching also clears the cells painted in the background's own colour,
    # which tmux and Neovim do for most of the screen
    programs.foot.package = onHyprland pkgs.foot "-o colors-dark.alpha=${alpha} -o colors-dark.alpha-mode=matching";
    # Ghostty has no `matching`: opacity-cells clears every painted cell, so
    # tmux and Neovim show through too
    programs.ghostty.package = onHyprland pkgs.ghostty "--background-opacity=${alpha} --background-opacity-cells=true";
    # Windows are blurred by decoration.blur already; a layer only by a
    # rule. ignore_alpha skips the clear corners round the bar and the
    # cards, which would otherwise blur as a square; so an opacity at or
    # below 0.5 loses the blur
    wayland.windowManager.hyprland.settings.layerrule = [
      "blur on, match:namespace ${layers}"
      "ignore_alpha 0.5, match:namespace ${layers}"
    ];
  };
}
