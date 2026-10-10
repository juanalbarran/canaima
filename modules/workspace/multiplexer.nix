# ./modules/workspace/multiplexer.nix
{
  flake.modules.homeManager.workspace = {lib, ...}: let
    # One combo reaches tmux under different names depending on how the
    # terminal encodes it, so every action is bound to all of them.
    bindAll = action: keys: map (key: "bind -n ${key} ${action}") keys;
  in {
    programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
      baseIndex = 1;
      mouse = true;
      keyMode = "vi";
      escapeTime = 10;
      focusEvents = true;
      historyLimit = 50000;
      extraConfig = lib.concatLines (
        [
          "set -s extended-keys on"
          "set -as terminal-features 'foot*:extkeys:RGB:clipboard'"
          "set -as terminal-features 'xterm-ghostty:extkeys:RGB:clipboard'"
          "set -s set-clipboard on"
          "set -g renumber-windows on"

          # Status bar: on top, window list centred, a blank line under it
          # as a gap. No colours: those come from the sarisarinama theme.
          "set -g status 2"
          "set -g status-format[1] ''"
          "set -g status-position top"
          "set -g status-justify absolute-centre"
          "set -g status-style bg=default,fg=default"
          "set -g status-left '[#S] '"
          "set -g status-left-length 50"
          "set -g status-right ''"
          "set -g window-status-format '#I #W'"
          "set -g window-status-current-format '#I #W'"
          "set -g window-status-separator '   '"
          "set -g window-status-style dim"
          "set -g window-status-current-style bold"

          "bind x confirm-before -p 'kill pane #P? (y/n)' kill-pane"
          "bind X confirm-before -p 'kill session #S? (y/n)' kill-session"
          "bind -T copy-mode-vi v send -X begin-selection"
          "bind -T copy-mode-vi y send -X copy-selection-and-cancel"
        ]
        ++ bindAll "previous-window" ["M-\\{" "M-S-\\{" "M-S-["]
        ++ bindAll "next-window" ["M-\\}" "M-S-\\}" "M-S-]"]
        ++ bindAll "swap-window -d -t -1" ["C-M-\\{" "C-M-S-\\{" "C-M-S-["]
        ++ bindAll "swap-window -d -t +1" ["C-M-\\}" "C-M-S-\\}" "C-M-S-]"]
      );
    };
  };
}
