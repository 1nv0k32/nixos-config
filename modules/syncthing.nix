{
  lib,
  pkgs,
  config,
  ...
}:
let
  shareUser = config.environment.sysConf.mainUser;
  sharePath = "/home/shared";
  shareName = config.networking.hostName;
in
{
  services = {
    syncthing = {
      enable = true;
      overrideFolders = false;
      overrideDevices = true;
      openDefaultPorts = true;
      settings = {
        options.urAccepted = -1;
        folders = {
          "${shareName}" = {
            path = sharePath;
            ignorePerms = false;
          };
        };
      };
    };
  };

  systemd.tmpfiles.rules = [ "d ${sharePath} 0770 ${shareUser} syncthing" ];
}

# vim:expandtab ts=2 sw=2
