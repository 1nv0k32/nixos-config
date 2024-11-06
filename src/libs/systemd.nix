{ ... }:
{
  systemd = {
    enableUnifiedCgroupHierarchy = true;
    watchdog = {
      runtimeTime = "off";
      rebootTime = "off";
      kexecTime = "off";
    };
    extraConfig = ''
      [Manager]
      LogLevel=err
      DefaultTimeoutStartSec=30s
      DefaultTimeoutStopSec=30s
      DefaultDeviceTimeoutSec=30s
      DefaultMemoryAccounting=yes
      DefaultTasksAccounting=yes
    '';
    user.extraConfig = ''
      [Manager]
      DefaultTimeoutStartSec=30s
      DefaultTimeoutStopSec=30s
    '';
  };
}
