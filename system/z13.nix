{ options, lib, ... }:
with lib;
{
  boot.kernelParams = options.boot.kernelParams.default ++ [ "amd_pstate=passive" ];
  boot.initrd.luks.devices."root".crypttabExtraOpts = [ "tpm2-device=auto" ];

  services = {
    fprintd.enable = false;
    power-profiles-daemon.enable = mkForce false;
    auto-cpufreq = {
      enable = true;
      settings = {
        "charger" = {
          governor = "ondemand";
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

# vim:expandtab ts=2 sw=2

