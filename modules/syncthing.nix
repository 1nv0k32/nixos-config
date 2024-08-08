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
          "Shared" = {
            path = sharePath;
            ignorePerms = false;
          };
        };
      };
    };
  };

  systemd.tmpfiles.rules = [ "d ${sharePath} 0755 ${shareUser} users" ];
}

# vim:expandtab ts=2 sw=2
