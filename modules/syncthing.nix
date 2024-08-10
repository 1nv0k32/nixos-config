{
  lib,
  pkgs,
  config,
  ...
}:
let
  dataDir = "/var/lib/syncthing";
  sharePath = "/home/shared";
  shareUser = config.environment.sysConf.mainUser;
  shareName = config.networking.hostName;
in
{
  services = {
    syncthing = {
      enable = true;
      dataDir = dataDir;
      user = shareUser;
      group = "users";
      overrideFolders = false;
      overrideDevices = false;
      openDefaultPorts = true;
      settings = {
        options.urAccepted = -1;
        folders = {
          "${shareName}-share" = {
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
