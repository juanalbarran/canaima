# home/modules/ui/themes/templates/tmux.nix
scheme: let
  bg = scheme.palette.base00;
  statusBg =
    if (builtins.match ".*dark.*" scheme.slug) != null
    then "default"
    else scheme.palette.base01;
in ''
  set -g status-style bg=${statusBg},fg=${scheme.palette.base05}
  set-window-option -g window-status-style bg=${statusBg},fg=${scheme.palette.base04}
  set-window-option -g window-status-current-style bg=${statusBg},fg=${scheme.palette.base0D}
  set -g pane-border-style fg=${scheme.palette.base03}
  set -g pane-active-border-style fg=${scheme.palette.base0D}
  set -g window-style bg=${bg}
  set -g window-active-style bg=${bg}
''
