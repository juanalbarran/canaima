# ./modules/workspace/multiplexer.nix
{
  flake.modules.homeManager.multiplexer = {lib, ...}: let
    # One combo reaches tmux under different names depending on how the
    # terminal encodes it, so every action is bound to all of them.
    bindAll = action: keys: map (key: "bind -n ${key} ${action}") keys;
  in {
    programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
      extraConfig = lib.concatLines (
        [
          "set -s extended-keys on"
          "set -as terminal-features 'foot*:extkeys'"
          "set -as terminal-features 'xterm-ghostty:extkeys'"
        ]
        ++ bindAll "previous-window" ["M-\\{" "M-S-\\{" "M-S-["]
        ++ bindAll "next-window" ["M-\\}" "M-S-\\}" "M-S-]"]
        ++ bindAll "swap-window -d -t -1" ["C-M-\\{" "C-M-S-\\{" "C-M-S-["]
        ++ bindAll "swap-window -d -t +1" ["C-M-\\}" "C-M-S-\\}" "C-M-S-]"]
      );
    };
  };
}
