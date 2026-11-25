# ./hosts/asus/default.nix
{
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.asus = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs;};
    modules = [
      ./_hardware.nix
      config.flake.modules.nixos.canaima
      {
        hostspec = {
          hostname = "canaima";
          isDocked = true;
          sshKeyName = "playa-el-agua";
          emailSecret = "personal/email";
          githubUser = "juanalbarran";
          defaultBrowser = "org.qutebrowser.qutebrowser.desktop";
          panelFontSize = 16;
          projectsRoot = "~/dev";
        };
      }
    ];
  };
}
