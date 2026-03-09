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

      # --- Font ---
      fn = "Jetbrains Mono 12"; # Font name and size

      # --- Dimensions & Positioning ---
      width-factor = 0.3; # Take up 30% of the screen width
      center = true; # Center the menu on the screen
      border = 2; # Add a border
      border-radius = 6; # Rounded corners

      # --- Colors (Hex codes without the '#' work best in some versions, but '#' is standard) ---
      # Background colors
      nb = "#1e1e2e"; # Normal background
      hb = "#313244"; # Highlighted background
      fb = "#1e1e2e"; # Filter background
      cb = "#1e1e2e"; # Cursor background
      ab = "#1e1e2e"; # Alternating background

      # Foreground colors
      nf = "#cdd6f4"; # Normal foreground
      hf = "#f9e2af"; # Highlighted foreground
      ff = "#cdd6f4"; # Filter foreground
      cf = "#f38ba8"; # Cursor foreground
      af = "#cdd6f4"; # Alternating foreground

      # Title/Prompt colors
      tb = "#1e1e2e"; # Title background
      tf = "#89b4fa"; # Title foreground

      # Border color
      bdr = "#89b4fa"; # Border color
    };
  };
  home.sessionVariables = {
    BEMENU_BACKEND = "wayland";
  };
}
