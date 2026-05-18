# home/modules/ui/sway/special-binds/default.nix
{
  xdg.configFile = {
    "sway/bindings/browser-binds.conf".source = ./browser-binds.conf;
    "sway/bindings/firefox-binds.conf".source = ./firefox-binds.conf;
    "sway/bindings/ai-binds.conf".source = ./ai-binds.conf;
    "sway/bindings/screenshot-binds.conf".source = ./screenshot-binds.conf;
    "qutebrowser/gemini-config.py".source = ./../../../browsers/qutebrowser/gemini-config.py;
    "sway/bindings/factorio-binds.conf".source = ./factorio-binds.conf;
    "sway/bindings/slack-binds.conf".source = ./slack-binds.conf;
    "sway/bindings/chrome-binds.conf".source = ./chrome-binds.conf;
  };
}
