{
  inputs,
  system,
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [
    (import ../src/extra.nix)
    (import ../pkgs/extra.nix)
  ];

  # boot.initrd.luks.devices."root".crypttabExtraOpts = [ "tpm2-device=auto" ];
  boot.initrd.luks.devices = lib.attrsets.mapAttrs (
    dev: devAttrs: devAttrs // { crypttabExtraOpts = [ "tpm2-device=auto" ]; }
  ) config.boot.initrd.luks.devices;

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
