{ customPkgs, stateVersion, ... }: { config, pkgs, lib, ... }:
let
  homeManager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
with lib;
{
  users.groups."ubridge" = {
    name = "ubridge";
  };

  users.users."rick" = {
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

  imports = [
    (import "${homeManager}/nixos")
    (import ./homes/rick.nix { inherit customPkgs stateVersion; systemConfig = config; })
    (import ./homes/guest.nix { inherit customPkgs stateVersion; systemConfig = config; })
  ];
}

# vim:expandtab ts=2 sw=2
