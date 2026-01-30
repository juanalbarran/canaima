# home/modules/ui/themes/templates/qutebrowser.nix
scheme: let
  # Determine if dark mode should be enabled based on the slug name
  isDark =
    if (builtins.match ".*dark.*" scheme.slug) != null
    then "True"
    else "False";
  # isDarkStr =
  #   if (builtins.match ".*dark.*" scheme.slug) != null
  #   then "dark"
  #   else "light";
  isDarkStr = "light";
in ''
  # Base16 Qutebrowser Template
  # Scheme: ${scheme.name}

  c = c  # noqa: F821
  config = config  # noqa: F821

  # --- Colors ---
  base00 = "${scheme.palette.base00}"
  base01 = "${scheme.palette.base01}"
  base02 = "${scheme.palette.base02}"
  base03 = "${scheme.palette.base03}"
  base04 = "${scheme.palette.base04}"
  base05 = "${scheme.palette.base05}"
  base06 = "${scheme.palette.base06}"
  base07 = "${scheme.palette.base07}"
  base08 = "${scheme.palette.base08}"
  base09 = "${scheme.palette.base09}"
  base0A = "${scheme.palette.base0A}"
  base0B = "${scheme.palette.base0B}"
  base0C = "${scheme.palette.base0C}"
  base0D = "${scheme.palette.base0D}"
  base0E = "${scheme.palette.base0E}"
  base0F = "${scheme.palette.base0F}"

  # Text color
  c.colors.completion.fg = base05
  c.colors.completion.odd.bg = base01
  c.colors.completion.even.bg = base00
  c.colors.completion.category.fg = base0A
  c.colors.completion.category.bg = base00
  c.colors.completion.category.border.top = base00
  c.colors.completion.category.border.bottom = base00
  c.colors.completion.item.selected.fg = base01
  c.colors.completion.item.selected.bg = base0E
  c.colors.completion.item.selected.border.top = base0E
  c.colors.completion.item.selected.border.bottom = base0E
  c.colors.completion.match.fg = base0B

  # Statusbar
  c.colors.statusbar.normal.fg = base0B
  c.colors.statusbar.normal.bg = base00
  c.colors.statusbar.insert.fg = base00
  c.colors.statusbar.insert.bg = base0D
  c.colors.statusbar.passthrough.fg = base00
  c.colors.statusbar.passthrough.bg = base0C
  c.colors.statusbar.command.fg = base05
  c.colors.statusbar.command.bg = base00
  c.colors.statusbar.url.fg = base05
  c.colors.statusbar.url.error.fg = base08
  c.colors.statusbar.url.warn.fg = base0E

  # Tabs
  c.colors.tabs.bar.bg = base00
  c.colors.tabs.odd.fg = base05
  c.colors.tabs.odd.bg = base01
  c.colors.tabs.even.fg = base05
  c.colors.tabs.even.bg = base00
  c.colors.tabs.selected.odd.fg = base00
  c.colors.tabs.selected.odd.bg = base0D
  c.colors.tabs.selected.even.fg = base00
  c.colors.tabs.selected.even.bg = base0D

  # Hints
  c.colors.hints.fg = base00
  c.colors.hints.bg = base0A
  c.colors.hints.match.fg = base05

  # --- Dark Mode Toggle ---
  c.colors.webpage.bg = base00
  c.colors.webpage.darkmode.enabled = ${isDark}
  c.colors.webpage.preferred_color_scheme = "${isDarkStr}"
''
