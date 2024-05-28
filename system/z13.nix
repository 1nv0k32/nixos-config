{
  inputs,
  system,
  options,
  config,
  pkgs,
  lib,
  ...
}:
let
  luksDevices = lib.attrsets.mapAttrsToList (name: device: name) config.boot.initrd.luks.devices;
in
with lib;
{
  imports = [
    (import ../src/extra.nix)
    (import ../pkgs/extra.nix)
  ];

  boot.initrd.luks.devices = lib.lists.forEach luksDevices (dev: {
    dev.crypttabExtraOpts = [ "tpm2-device=auto" ];
  });

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
