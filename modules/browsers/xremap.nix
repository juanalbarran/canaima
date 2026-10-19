# ./modules/browsers/xremap.nix
{inputs, ...}: {
  flake.modules.homeManager.browsers = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.xremap-flake.homeManagerModules.default];
    # Chrome can't rebind its tab keys, so xremap gives it the same
    # alt+shift+[ / ] as tmux, qutebrowser and Tridactyl. It needs to read
    # /dev/input and write /dev/uinput: on Ubuntu that's the input and uinput
    # groups plus a udev rule, on NixOS a NixOS-side half that isn't written
    # yet, so it's off there
    services.xremap = lib.mkIf (!config.hostspec.isNixOS) {
      enable = true;
      withWlroots = true;
      config.keymap = [
        {
          name = "Chrome tab switching";
          application.only = ["Google-chrome" "google-chrome"];
          remap = {
            "Alt-Shift-leftbrace" = "Ctrl-Shift-Tab";
            "Alt-Shift-rightbrace" = "Ctrl-Tab";
          };
        }
      ];
    };
  };
}
