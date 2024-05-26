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
  userPkgs = (import ../pkgs/user.nix { inherit inputs pkgs; }).userPkgs;
  gnomeExtensions = (import ../pkgs/gnome-ext.nix { inherit inputs pkgs; }).gnomeExtensions;
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

  home-manager.users =
    let
      baseImport = (
        import ./homes/base.nix {
          inherit gnomeExtensions;
          systemConfig = config;
        }
      );
    in
    {
      "${mainUser}" =
        { ... }:
        {
          imports = [ baseImport ];
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
          imports = [ baseImport ];
          home = {
            username = "guest";
            stateVersion = stateVersion;
          };
        };
    };
}

# vim:expandtab ts=2 sw=2
