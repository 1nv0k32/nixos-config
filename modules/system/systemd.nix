{ ... }:
{
  flake.modules.nixos.system-systemd = { ... }: {
    boot.initrd.systemd = {
      enable = true;
      settings.Manager = {
        LogLevel = "err";
        DefaultTimeoutStartSec = 30;
        DefaultTimeoutStopSec = 30;
        DefaultDeviceTimeoutSec = 30;
        DefaultMemoryAccounting = true;
        DefaultTasksAccounting = true;
      };
    };
    systemd = {
      settings.Manager = {
        LogLevel = "err";
        DefaultTimeoutStartSec = 30;
        DefaultTimeoutStopSec = 30;
        DefaultDeviceTimeoutSec = 30;
        DefaultMemoryAccounting = true;
        DefaultTasksAccounting = true;
      };
      user.extraConfig = ''
        [Manager]
        DefaultTimeoutStartSec=30s
        DefaultTimeoutStopSec=30s
      '';
    };
  };
}
