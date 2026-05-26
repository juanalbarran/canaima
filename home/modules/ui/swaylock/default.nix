# home/modules/ui/swaylock/default.nix
{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      scaling = "fill";
      # Appearance
      color = "1e1e2e";
      font = "JetBrainsMono Nerd Font";
      font-size = 24;

      # Indicators
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;

      # Effects (Specific to swaylock-effects)
      screenshots = true;
      clock = true;
      effect-blur = "7x5";
      # effect-vignette = "0.5:0.5";

      # Colors
      ring-color = "3b4252";
      key-hl-color = "88c0d0";
      text-color = "eceff4";
      line-color = "00000000"; # invisible line

      # Behavior
      daemonize = true;
      ignore-empty-password = true;
      show-failed-attempts = true;
    };
  };

  # On non-NixOS, Nix's libpam is used by swaylock and has two quirks:
  #   1. pam_unix.so is hardcoded to call /run/wrappers/bin/unix_chkpwd (a NixOS path).
  #   2. Nix's libpam does not support the @include directive used in Ubuntu's PAM configs.
  # Fix 1: symlink /run/wrappers/bin/unix_chkpwd → system unix_chkpwd via systemd-tmpfiles.
  # Fix 2: write /etc/pam.d/swaylock with a plain `include` (not via `login` which uses @include).
  home.activation.swaylockPamWrappers = lib.mkIf (!config.hostSpec.isNixOS) (
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -f /etc/tmpfiles.d/nix-wrappers.conf ]; then
        echo 'swaylock: creating /etc/tmpfiles.d/nix-wrappers.conf (requires sudo)'
        TMPFILE=$(mktemp)
        printf '%s\n' \
          'd /run/wrappers 0755 root root -' \
          'd /run/wrappers/bin 0755 root root -' \
          'L+ /run/wrappers/bin/unix_chkpwd - - - - /sbin/unix_chkpwd' > "$TMPFILE"
        $DRY_RUN_CMD /usr/bin/sudo cp "$TMPFILE" /etc/tmpfiles.d/nix-wrappers.conf
        rm -f "$TMPFILE"
      fi
      if [ ! -e /run/wrappers/bin/unix_chkpwd ]; then
        $DRY_RUN_CMD /usr/bin/sudo systemd-tmpfiles --create /etc/tmpfiles.d/nix-wrappers.conf
      fi
      PAM_SWAYLOCK=/etc/pam.d/swaylock
      EXPECTED='auth include common-auth'
      if [ "$(cat "$PAM_SWAYLOCK" 2>/dev/null)" != "$EXPECTED" ]; then
        echo 'swaylock: writing /etc/pam.d/swaylock (requires sudo)'
        $DRY_RUN_CMD /usr/bin/sudo bash -c "printf '%s\n' '$EXPECTED' > $PAM_SWAYLOCK"
      fi
    ''
  );
}
