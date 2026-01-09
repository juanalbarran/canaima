# home/modules/fastfetch/default.nix
{
  imports = [
    ./modules.nix
  ];
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        type = "small";
        padding = {
          top = 2;
          left = 5;
        };
      };
      # logo = {
      #   source = "${./../../../assets/jacko/jacko03.jpeg}";
      #   type = "auto";
      #   height = 16;
      #   width = 32;
      #   padding = {
      #     top = 1;
      #     left = 2;
      #     right = 4;
      #   };
      # };

      display = {
        separator = " ";
      };
    };
  };
}
