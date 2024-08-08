{
  lib,
  pkgs,
  config,
  ...
}:
let
  shareUser = config.environment.sysConf.mainUser;
  sharePath = "/home/shared";
in
{
  services = {
    syncthing = {
      enable = true;
      overrideFolders = false;
      overrideDevices = true;
      openDefaultPorts = true;
      settings = {
        folders = {
          sharePath = {
            path = sharePath;
            ignorePerms = false;
          };
        };
      };
    };
  };

  systemd.tmpfiles.rules = [ "d ${sharePath} 0660 ${shareUser} syncthing" ];
}

# vim:expandtab ts=2 sw=2
