# home/modules/ui/themes/templates/foot.nix
scheme: let
  clean = color: builtins.substring 1 6 color;
in ''
  [colors]
  background=${clean scheme.palette.base00}
  foreground=${clean scheme.palette.base05}
  regular0=${clean scheme.palette.base00} # black
  regular1=${clean scheme.palette.base08} # red
  regular2=${clean scheme.palette.base0B} # green
  regular3=${clean scheme.palette.base0A} # yellow
  regular4=${clean scheme.palette.base0D} # blue
  regular5=${clean scheme.palette.base0E} # magenta
  regular6=${clean scheme.palette.base0C} # cyan
  regular7=${clean scheme.palette.base05} # white

  bright0=${clean scheme.palette.base03}   # bright black
  bright1=${clean scheme.palette.base08}   # bright red
  bright2=${clean scheme.palette.base0B}   # bright green
  bright3=${clean scheme.palette.base0A}   # bright yellow
  bright4=${clean scheme.palette.base0D}   # bright blue
  bright5=${clean scheme.palette.base0E}   # bright magenta
  bright6=${clean scheme.palette.base0C}   # bright cyan
  bright7=${clean scheme.palette.base07}   # bright white

  selection-foreground=${clean scheme.palette.base05}
  selection-background=${clean scheme.palette.base02}
  urls=${clean scheme.palette.base0D}
''
