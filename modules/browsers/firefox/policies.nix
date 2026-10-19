# ./modules/browsers/firefox/policies.nix
{
  flake.modules.homeManager.browsers = {config, ...}: {
    # about:policies#documentation, or https://mozilla.github.io/policy-templates
    programs.firefox.policies = {
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;
      DefaultDownloadDirectory = "${config.home.homeDirectory}/Downloads";
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      # Passwords live in Proton Pass
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
    };
  };
}
