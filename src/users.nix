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
  userPkgs = (import ../pkgs/user.nix { inherit inputs pkgs config; }).userPkgs;
  gnomeExtensions = (import ../pkgs/gnome-ext.nix { inherit pkgs; }).gnomeExtensions;
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
    packages = userPkgs ++ gnomeExtensions;
  };

  users.users."guest" = {
    uid = 1001;
    isNormalUser = true;
    packages = userPkgs ++ gnomeExtensions;
  };

  home-manager.users."${mainUser}" =
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

      imports = [
        (import ./homes/base.nix {
          inherit gnomeExtensions;
          systemConfig = config;
        })
      ];
    };

  home-manager.users."guest" =
    { ... }:
    {
      home = {
        username = "guest";
        stateVersion = stateVersion;
      };

      imports = [
        (import ./homes/base.nix {
          inherit gnomeExtensions;
          systemConfig = config;
        })
      ];
    };
}

# vim:expandtab ts=2 sw=2
