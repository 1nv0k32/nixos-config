{ config, lib, ... }:
let
  cfg = config.environment.sysConf;
in
{
  users.users."${cfg.user.name}" = {
    initialPassword = lib.mkForce null;
  };

  avf = {
    enableGraphics = true;
    defaultUser = cfg.user.name;
    enableConfigReplace = true;
    vmConfig = {
      memory_mib = lib.mkForce 8192;
    };
  };
}
