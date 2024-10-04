{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  raspberry-pi-nix.board = "bcm2712";
  hardware = {
    bluetooth.enable = true;
    raspberry-pi = {
      config.all.base-dt-params = {
        krnbt = {
          enable = true;
          value = "on";
        };
      };
    };
  };
  services = {
    connman = {
      enable = true;
    };
  };
}
