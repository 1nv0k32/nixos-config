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
