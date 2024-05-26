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
  customPkgs = pkgs.callPackage (import ./pkgs.nix) { inherit inputs; };
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
    packages = customPkgs.USER ++ customPkgs.GNOME_EXT;
  };

  users.users."guest" = {
    uid = 1001;
    isNormalUser = true;
    packages = customPkgs.USER ++ customPkgs.GNOME_EXT;
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
          inherit customPkgs;
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
          inherit customPkgs;
          systemConfig = config;
        })
      ];
    };
}

# vim:expandtab ts=2 sw=2
