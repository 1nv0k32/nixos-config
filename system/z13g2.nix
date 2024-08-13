{ pkgs, lib, ... }:
with lib;
{
  imports = [
    (import ../src/extra.nix)
    (import ../pkgs/extra.nix)
    (import ../overrides/initrd-luks.nix)
  ];

  networking.networkmanager.fccUnlockScripts = [
    {
      id = "2c7c:030a";
      path = "${pkgs.modemmanager}/share/ModemManager/fcc-unlock.available.d/2c7c:030a";
    }
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    extraModprobeConfig = "options kvm_amd nested=1";
    kernelParams = [
      "acpi_backlight=native"
      "amd_pstate=active"
      "amdgpu"
    ];
  };

  hardware = {
    amdgpu = {
      initrd.enable = true;
      amdvlk.enable = true;
    };
    opengl = {
      driSupport = true;
      extraPackages = with pkgs; [ amdvlk ];
    };
  };

  environment.variables = {
    "VDPAU_DRIVER" = "radeonsi";
    "LIBVA_DRIVER_NAME" = "radeonsi";
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
          governor = "schedutil";
          turbo = "auto";
        };
        "battery" = {
          governor = "ondemand";
          scaling_min_freq = 400000;
          scaling_max_freq = 1600000;
          turbo = "never";
        };
      };
    };
  };
}
