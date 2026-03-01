# home/modules/salesforce/default.nix
{
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      salesforce.salesforcedx-vscode # The main SF extension
      vscjava.vscode-java-pack # Required for Apex support
    ];
  };
  home.packages = with pkgs; [
    pkgs-unstable.salesforce-cli
    jq
    nodejs_20
  ];
}
