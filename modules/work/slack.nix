# ./modules/work/slack.nix
{
  flake.modules.homeManager.work = {pkgs, ...}: {
    home.packages = [pkgs.slack];
    # Replaces Sway's default mod+s (stacking layout)
    ui.apps.slack = {
      command = "slack";
      appId = "Slack";
      workspace = 5;
      bind.key = "s";
    };
  };
}
