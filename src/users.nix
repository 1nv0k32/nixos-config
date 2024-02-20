{ customPkgs }: { config, pkgs, lib, ... }:
let
  homeManager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
with lib;
{
  imports = [
    (import "${homeManager}/nixos")
  ];

  users.groups."ubridge" = {
    name = "ubridge";
  };

  users.users."${config.sysConf.mainUser}" = {
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

  home-manager.users."${config.sysConf.mainUser}" = { ... }: {
    home = {
      username = config.sysConf.mainUser;
    };

    imports = [ (import ./homes/base.nix { inherit customPkgs; systemConfig = config; }) ];
  };

  home-manager.users."guest" = { ... }: {
    home = {
      username = "guest";
    };

    imports = [ (import ./homes/base.nix { inherit customPkgs; systemConfig = config; }) ];
  };
}

# vim:expandtab ts=2 sw=2
