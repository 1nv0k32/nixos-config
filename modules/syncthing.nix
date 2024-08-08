{
  lib,
  pkgs,
  config,
  ...
}:
let
  dataDir = "/var/lib/syncthing";
  shareUser = config.environment.sysConf.mainUser;
  sharePath = "/home/shared";
  shareName = config.networking.hostName;
in
{
  services = {
    syncthing = {
      enable = true;
      dataDir = dataDir;
      user = shareUser;
      group = "users";
      overrideFolders = true;
      overrideDevices = true;
      openDefaultPorts = true;
      settings = {
        options.urAccepted = -1;
        folders = {
          "${shareName}" = {
            path = sharePath;
          };
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0700 ${shareUser} users"
    "d ${sharePath} 0700 ${shareUser} users"
  ];
}

# vim:expandtab ts=2 sw=2
