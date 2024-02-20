{ customPkgs, stateVersion, config, pkgs, lib, ... }:
let
  homeManager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-${stateVersion}.tar.gz";
  mainUser = "rick";
in
with lib;
{
  imports = [
    (import "${homeManager}/nixos")
  ];

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

  home-manager.users."${mainUser}" = { ... }: {
    home = {
      username = mainUser;
    };

    imports = [ (import ./homes/base.nix { inherit stateVersion customPkgs; systemConfig = config; }) ];
  };

  home-manager.users."guest" = { ... }: {
    home = {
      username = "guest";
    };

    imports = [ (import ./homes/base.nix { inherit stateVersion customPkgs; systemConfig = config; }) ];
  };
}

# vim:expandtab ts=2 sw=2
