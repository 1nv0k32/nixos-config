{
  inputs,
  options,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [
    (import ../src/extra.nix { inherit inputs pkgs lib; })
    (import ../pkgs/extra.nix { inherit inputs pkgs lib; })
  ];
  boot.kernelParams = options.boot.kernelParams.default ++ [
    "amd_pstate=passive"
    "amd_iommu=on"
  ];
  boot.initrd.luks.devices."root".crypttabExtraOpts = [ "tpm2-device=auto" ];

  services = {
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 90;
        STOP_CHARGE_THRESH_BAT0 = 99;
      };
    };
    power-profiles-daemon.enable = mkForce false;
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
  };
}

# vim:expandtab ts=2 sw=2
