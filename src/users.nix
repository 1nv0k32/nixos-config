{ config, lib, ... }:
let
  mainUser = config.environment.sysConf.mainUser;
in
{
  users.groups."ubridge" = {
    name = "ubridge";
  };

  users.users."${mainUser}" = {
    uid = 1000;
    isNormalUser = true;
    linger = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "docker"
      "ubridge"
      "wireshark"
    ];
  };

  users.users."guest" = {
    uid = 1001;
    isNormalUser = true;
    password = "guest";
  };

  home-manager.users = {
    "${mainUser}" =
      { ... }:
      {
        home.username = mainUser;

        programs.git = {
          userName = config.environment.sysConf.gitUserName;
          userEmail = config.environment.sysConf.gitEmail;
          signing = lib.mkIf (config.environment.sysConf.gitGpgKey != null) {
            key = config.environment.sysConf.gitGpgKey;
          };
        };
      };

    "guest" =
      { ... }:
      {
        home.username = "guest";
      };
  };
}
