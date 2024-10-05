{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  imports = [
    (import ../modules/media.nix)
    (import ../modules/k3s.nix)
  ];

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

  networking = {
    firewall.enable = false;
    useDHCP = false;
    interfaces = {
      wlan0.useDHCP = true;
      eth0.useDHCP = true;
    };
  };

  services = {
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
