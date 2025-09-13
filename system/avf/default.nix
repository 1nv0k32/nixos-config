{ config, ... }:
let
  cfg = config.environment.sysConf;
in
{
  users.users."${cfg.user.name}" = {
    initialPassword = null;
  };

  avf = {
    defaultUser = cfg.user.name;
    vmConfig = {
      memory_mib = 8192;
    };
  };
}
