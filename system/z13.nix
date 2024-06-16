{
  inputs,
  system,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [
    (import ../src/extra.nix)
    (import ../pkgs/extra.nix)
    (import ../overlays/initrd-luks.nix)
  ];

  networking = {
    wlanInterfaces = {
      wlan0 = {
        device = "wlp1s0";
        type = "managed";
        mac = "02:b0:de:ac:ec:29";
      };
      wlan1 = {
        device = "wlp1s0";
        type = "managed";
        mac = "02:b0:de:ac:ec:30";
      };
    };
    networkmanager = {
      fccUnlockScripts = [
        {
          id = "2c7c:030a";
          path = "${pkgs.modemmanager}/share/ModemManager/fcc-unlock.available.d/2c7c:030a";
        }
      ];
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    extraModprobeConfig = "options kvm_amd nested=1";
    initrd.kernelModules = [ "amdgpu" ];
  };

  services = {
    power-profiles-daemon.enable = mkForce false;
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 90;
        STOP_CHARGE_THRESH_BAT0 = 100;
      };
    };
    auto-cpufreq = {
      enable = true;
      settings = {
        "charger" = {
          governor = "performance";
          turbo = "always";
        };
        "battery" = {
          governor = "ondemand";
          scaling_min_freq = 400000;
          scaling_max_freq = 1600000;
          turbo = "never";
        };
      };
    };
    keyd = {
      enable = true;
      keyboards.internal = {
        ids = [ "0001:0001" ];
        settings = {
          main = {
            "102nd" = "layer(shift)";
          };
        };
      };
    };
  };
}

# vim:expandtab ts=2 sw=2
