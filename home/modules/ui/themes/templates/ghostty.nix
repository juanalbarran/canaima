# home/modules/ui/themes/templates/ghostty.nix
scheme: ''
  # Base16 Ghostty Template
  # Scheme: ${scheme.name}

  background = ${scheme.palette.base00}
  foreground = ${scheme.palette.base05}
  selection-background = ${scheme.palette.base02}
  selection-foreground = ${scheme.palette.base05}
  cursor-color = ${scheme.palette.base05}
  cursor-text = ${scheme.palette.base00}

  # Normal Colors
  palette = 0=${scheme.palette.base00}
  palette = 1=${scheme.palette.base08}
  palette = 2=${scheme.palette.base0B}
  palette = 3=${scheme.palette.base0A}
  palette = 4=${scheme.palette.base0D}
  palette = 5=${scheme.palette.base0E}
  palette = 6=${scheme.palette.base0C}
  palette = 7=${scheme.palette.base05}

  # Bright Colors
  palette = 8=${scheme.palette.base03}
  palette = 9=${scheme.palette.base08}
  palette = 10=${scheme.palette.base0B}
  palette = 11=${scheme.palette.base0A}
  palette = 12=${scheme.palette.base0D}
  palette = 13=${scheme.palette.base0E}
  palette = 14=${scheme.palette.base0C}
  palette = 15=${scheme.palette.base07}
''
