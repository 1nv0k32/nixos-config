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
      user = shareUser;
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

  systemd.tmpfiles.settings = {
    "Shared" = {
      sharePath = {
        d = {
          user = shareUser;
          group = "users";
          mode = "0755";
        };
      };
    };
  };
}

# vim:expandtab ts=2 sw=2
