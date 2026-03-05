# home/modules/salesforce/default.nix
{
  pkgs,
  inputs,
  ...
}: let
  # Define the missing Salesforce extension manually
  salesforce-extension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    name = "salesforcedx-vscode";
    publisher = "salesforce";
    version = "60.4.1";
    sha256 = "sha256-g+GdVForEFQl8NMeBTky5BUykBXbau7UyuhZAGhpdP8=";
  };
in {
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      salesforce-extension
      vscjava.vscode-java-pack
    ];
  };
  home.packages = with pkgs; [
    inputs.sfdx-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    jq
    nodejs_20
    jdk17
  ];
}
