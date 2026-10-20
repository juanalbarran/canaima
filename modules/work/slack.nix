# ./modules/work/slack.nix
{
  flake.modules.homeManager.work = {pkgs, ...}: {
    home.packages = [pkgs.slack];
    # Slack's sign-in in the browser comes back to the app through slack://
    xdg.mimeApps = {
      enable = true;
      defaultApplications."x-scheme-handler/slack" = "slack.desktop";
    };
    # Replaces Sway's default mod+s (stacking layout). Slack runs native
    # Wayland, whose app_id is lowercase; "Slack" is only its X11 class
    ui.apps.slack = {
      command = "slack";
      appId = "slack";
      workspace = 5;
      bind.key = "s";
    };
  };
}
