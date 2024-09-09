{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  boot.kernelParams = [ "dtb=\\bcm2712-rpi-5-b.dtb" ];
  services = {
    connman = {
      enable = true;
    };
  };
}
