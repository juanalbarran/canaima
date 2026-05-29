scheme: ''
  * {
    font-family: "JetBrains Mono Nerd Font", monospace;
    font-size: 16px;
  }

  window {
    margin: 0px;
    padding: 20px;
    background-color: ${scheme.palette.base00};
    opacity: 0.95;
  }

  #outer-box {
    padding: 10px;
    border: 2px solid ${scheme.palette.base0D};
    background-color: ${scheme.palette.base00};
  }

  #inner-box {
    margin: 0;
    padding: 0;
    border: none;
    background-color: ${scheme.palette.base00};
  }

  #scroll {
    margin: 0;
    padding: 0;
    border: none;
  }

  #input {
    margin: 0 0 8px 0;
    padding: 10px;
    border: none;
    background-color: ${scheme.palette.base01};
    background-image: none;
    color: ${scheme.palette.base05};
    outline: none;
    box-shadow: none;
  }

  #input:focus {
    outline: none;
    box-shadow: none;
    border: none;
    background-image: none;
  }

  #text {
    margin: 5px;
    border: none;
    color: ${scheme.palette.base05};
  }

  #entry {
    background-color: ${scheme.palette.base00};
  }

  #entry:selected {
    outline: none;
    border: none;
    background-color: ${scheme.palette.base00};
  }

  #entry:selected #text {
    color: ${scheme.palette.base0D};
  }
''
