{config, ...}: {
  # Refer to https://mozilla.github.io/policy-templates or `about:policies#documentation` in firefox
  programs.firefox.policies = {
    AppAutoUpdate = false; # Disable automatic application update
    BackgroundAppUpdate = false; # Disable automatic application update in the background, when the application is not running.
    DefaultDownloadDirectory = "${config.home.homeDirectory}/downloads";
    DisableBuiltinPDFViewer = false;
    DisableFirefoxStudies = true;
    DisableFirefoxAccounts = false; # Enable Firefox Sync
    DisablePocket = true;
    DisableTelemetry = true;
    DontCheckDefaultBrowser = true;
    OfferToSaveLogins = false; # Managed by Proton
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
      EmailTracking = true;
      # Exceptions = ["https://example.com"]
    };
  };
}
