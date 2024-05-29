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
  devicesModule =
    { name, config, ... }:
    {
      options.crypttabExtraOpts = mkOption {
        default = (options.boot.initrd.luks.devices.type.getSubOptions [ ]).crypttabExtraOpts.default ++ [
          "tpm2-device=auto"
        ];
      };
    };
in
with lib;
{
  imports = [
    (import ../src/extra.nix)
    (import ../pkgs/extra.nix)
  ];

  # boot.initrd.luks.devices."root".crypttabExtraOpts = [ "tpm2-device=auto" ];
  options.boot.initrd.luks.devices = mkOption {
    type = types.attrsOf (types.submodule devicesModule);
  };

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
