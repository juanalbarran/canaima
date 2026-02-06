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
    border-radius: 0px;
    background-color: ${scheme.palette.base00};
    background-image: none;
    color: ${scheme.palette.base05};
    outline: none;
    box-shadow: none;
  }

  #input:focus {
    border: none;
    outline: none;
    border-radius: 0px;
    background-image: none;
    box-shadow: none;
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
