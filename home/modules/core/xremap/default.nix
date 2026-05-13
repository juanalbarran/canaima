# home/modules/core/xremap/default.nix
{inputs, ...}: {
  imports = [inputs.xremap-flake.homeManagerModules.default];

  services.xremap = {
    enable = true;

    withWlroots = true;

    config = {
      keymap = [
        {
          name = "Chrome tab Switching";
          application = {
            only = ["Google-chrome" "google-chrome"];
          };
          remap = {
            "Alt-Shift-leftbrace" = "Ctrl-Shift-Tab";
            "Alt-Shift-rightbrace" = "Ctrl-Tab";
          };
        }
      ];
    };
  };
}
