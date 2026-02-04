# home/modules/ui/themes/templates/wofi.nix
scheme: ''
  window {
    margin: 0px;
    border: 2px solid ${scheme.palette.base0D}; /* Accent (Blue-ish) */
    background-color: ${scheme.palette.base00}; /* Base Background */
    font-family: "JetBrains Mono Nerd Font", monospace;
    font-size: 14px;
  }

  #input {
    margin: 5px;
    border: none;
    background-color: ${scheme.palette.base00};
    color: ${scheme.palette.base05};
  }

  #inner-box {
    margin: 5px;
    border: none;
    background-color: ${scheme.palette.base00};
  }

  #outer-box {
    margin: 5px;
    border: none;
    background-color: ${scheme.palette.base00};
  }

  #scroll {
    margin: 0px;
    border: none;
  }

  #text {
    margin: 5px;
    border: none;
    color: ${scheme.palette.base05}; /* Main Text */
  }

  #entry:selected {
    background-color: ${scheme.palette.base0D}; /* Accent */
    outline: none;
  }

  #entry:selected #text {
    color: ${scheme.palette.base00}; /* Contrast Text on selection */
  }
''
