{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  users.users."${config.environment.sysConf.mainUser}".initialPassword = "rpi5";
  services = {
    connman = {
      enable = true;
    };
  };
}
