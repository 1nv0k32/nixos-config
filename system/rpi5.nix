{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  users.users.root.initialPassword = "root";
  sdImage.compressImage = false;
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
    openssh = {
      enable = true;
      listenAddresses = [
        {
          addr = "0.0.0.0";
          port = 22;
        }
      ];
    };
  };
}
