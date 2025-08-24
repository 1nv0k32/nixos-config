{ ... }:
let
  SYSTEMD_CONFIG = ''
    [Manager]
    LogLevel=err
    DefaultTimeoutStartSec=30s
    DefaultTimeoutStopSec=30s
    DefaultDeviceTimeoutSec=30s
    DefaultMemoryAccounting=yes
    DefaultTasksAccounting=yes
  '';
in
{
  boot.initrd.systemd = {
    enable = true;
    extraConfig = SYSTEMD_CONFIG;
  };
  systemd = {
    extraConfig = SYSTEMD_CONFIG;
    user.extraConfig = ''
      [Manager]
      DefaultTimeoutStartSec=30s
      DefaultTimeoutStopSec=30s
    '';
  };
}
