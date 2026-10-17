# ./modules/core/printers.nix
{
  flake.modules.nixos.core = {pkgs, ...}: {
    # CUPS print server, as omarchy's cups.service
    services.printing = {
      enable = true;
      # Canon's PIXMA driver, the TS200 doesn't speak driverless IPP
      drivers = [pkgs.cnijfilter2];
      # omarchy keeps cups-browsed (auto-created network queues) off
      browsed.enable = false;
    };
    # Driverless printing for USB printers that speak IPP-over-USB
    services.ipp-usb.enable = true;
    # mDNS, which ipp-usb uses to announce the printer to CUPS
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    # "Print Settings" GUI plus its udev/dbus helper that sets up USB printers on plug-in
    programs.system-config-printer.enable = true;
  };

  flake.modules.homeManager.shell = {
    config,
    lib,
    ...
  }: {
    programs.sarisarinama.menus.root = lib.mkIf config.hostspec.isNixOS [
      {
        icon = "󰐪 ";
        label = "Printers";
        action = "system-config-printer";
      }
    ];
  };
}
