{ config, ... }:
{
  wsl = {
    enable = true;
    startMenuLaunchers = true;
    defaultUser = config.environment.sysConf.mainUser;
  };
}
