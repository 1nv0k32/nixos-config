{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  users.users."${config.environment.sysConf.mainUser}".initialPassword = "rpi5";
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    initrd.availableKernelModules = [
      "nvme"
      "usbhid"
      "usb_storage"
    ];
  };
  services = {
    connman = {
      enable = true;
      extraFlags = [ "--with-dns-backend=systemd-resolved" ];
    };
  };
}
