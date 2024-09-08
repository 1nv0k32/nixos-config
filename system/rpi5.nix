{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  users.users."${config.environment.sysConf.mainUser}".initialPassword = "rpi5";
  boot.kernelPackages = pkgs.pkgs-unstable.linuxPackages_rpi4;
  services = {
    connman = {
      enable = true;
      extraFlags = [ "--with-dns-backend=systemd-resolved" ];
    };
  };
}
