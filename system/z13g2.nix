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
        CPU_BOOST_ON_BAT = 0;
        CPU_ENERGY_PERF_POLICY_ON_BAT = balance_power;
        CPU_ENERGY_PERF_POLICY_ON_AC = balance_performance;
      };
    };
  };
}
