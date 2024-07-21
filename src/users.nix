{
  inputs,
  stateVersion,
  config,
  pkgs,
  lib,
  ...
}:
let
  mainUser = config.environment.sysConf.mainUser;
in
with lib;
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

  home-manager.sharedModules = [ (import ../home/base.nix) ];
  home-manager.users = {
    "${mainUser}" =
      { ... }:
      {
        home = {
          username = mainUser;
          stateVersion = stateVersion;
        };

        programs.git = {
          userName = config.environment.sysConf.gitUserName;
          userEmail = config.environment.sysConf.gitEmail;
        };
      };

    "guest" =
      { ... }:
      {
        home = {
          username = "guest";
          stateVersion = stateVersion;
        };
      };
  };
}

# vim:expandtab ts=2 sw=2
