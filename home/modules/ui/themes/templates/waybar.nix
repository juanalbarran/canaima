# home/modules/ui/themes/templates/waybar.nix
scheme: ''
  /* Generates standard Base16 variables */
  @define-color base00 ${scheme.palette.base00};
  @define-color base01 ${scheme.palette.base01};
  @define-color base02 ${scheme.palette.base02};
  @define-color base03 ${scheme.palette.base03};
  @define-color base04 ${scheme.palette.base04};
  @define-color base05 ${scheme.palette.base05};
  @define-color base06 ${scheme.palette.base06};
  @define-color base07 ${scheme.palette.base07};
  @define-color base08 ${scheme.palette.base08};
  @define-color base09 ${scheme.palette.base09};
  @define-color base0A ${scheme.palette.base0A};
  @define-color base0B ${scheme.palette.base0B};
  @define-color base0C ${scheme.palette.base0C};
  @define-color base0D ${scheme.palette.base0D};
  @define-color base0E ${scheme.palette.base0E};
  @define-color base0F ${scheme.palette.base0F};

  @define-color background ${scheme.palette.base00};
  @define-color text       ${scheme.palette.base05};
  @define-color accent     ${scheme.palette.base0D};
  @define-color urgent     ${scheme.palette.base08};
  @define-color hover      ${scheme.palette.base0A};
''
