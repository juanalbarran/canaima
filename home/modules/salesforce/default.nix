# home/modules/salesforce/default.nix
{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      salesforce.salesforcedx-vscode # The main SF extension
      vscjava.vscode-java-pack # Required for Apex support
    ];
  };
}
