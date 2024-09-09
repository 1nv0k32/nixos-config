{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  boot = {
    kernelParams = [ "dtb=\\bcm2712-rpi-5-b.dtb" ];
    loader = {
      efi.canTouchEfiVariables = false;
    };
  };
  services = {
    connman = {
      enable = true;
    };
  };
}
