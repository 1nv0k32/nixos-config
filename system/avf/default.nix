{ config, ... }:
let
  cfg = config.environment.sysConf;
in
{
  avf = {
    defaultUser = cfg.user.name;
    vmConfig = {
      memory_mib = 8192;
    };
  };
}
