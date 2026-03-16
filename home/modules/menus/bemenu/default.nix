# home/modules/menus/bemenu/default.nix
{
  config,
  pkgs,
  ...
}: {
  programs.bemenu = {
    enable = true;

    settings = {
      # --- General Behavior ---
      ignorecase = true; # Ignore case when filtering
      wrap = true; # Wrap around at the ends of the list
      list = 10; # Number of lines to show vertically (like dmenu)
      prompt = "Projects:"; # Default prompt

      # --- Padding & Sizing ---
      line-height = 30; # dmenu is usually 18-20px tall

      # --- Font ---
      fn = "Jetbrains Mono 12"; # Font name and size

      # --- Dimensions & Positioning ---
      width-factor = 0.3; # Take up 30% of the screen width
      center = true; # Center the menu on the screen
      border = 2; # Add a border
      border-radius = 0; # Rounded corners

      # --- Colors (Hex codes without the '#' work best in some versions, but '#' is standard) ---
      # Background colors
      nb = "#131314"; # Normal background
      hb = "#005577"; # Highlighted background
      fb = "#131314"; # Filter background
      cb = "#131314"; # Cursor background
      ab = "#131314"; # Alternating background

      # Foreground colors
      nf = "#cdd6f4"; # Normal foreground
      hf = "#EEEEEE"; # Highlighted foreground
      ff = "#bbbbbb"; # Filter foreground
      cf = "#eeeeee"; # Cursor foreground
      af = "#cdd6f4"; # Alternating foreground

      # Title/Prompt colors
      tb = "#005577"; # Title background
      tf = "#eeeeee"; # Title foreground

      # Border color
      bdr = "#005577"; # Border color
    };
  };
  home.sessionVariables = {
    BEMENU_BACKEND = "wayland";
  };
}
