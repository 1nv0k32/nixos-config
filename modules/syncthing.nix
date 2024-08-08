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

  systemd.tmpfiles.rules = [ "d ${sharePath} 0770 ${shareUser} users" ];
}

# vim:expandtab ts=2 sw=2
