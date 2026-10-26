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
    # Off, the TS200 has no IPP-over-USB and ipp-usb kept reclaiming its USB interface every few seconds which stalled CUPS' usb backend mid-job
    services.ipp-usb.enable = false;
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
    programs.sarisarinama.menus.services = lib.mkIf config.hostspec.isNixOS [
      {
        icon = "󰐪 ";
        label = "Printers";
        action = "system-config-printer";
      }
    ];
  };
}
