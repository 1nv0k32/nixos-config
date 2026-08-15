{
  self,
  config,
  lib,
  pkgs,
  ...
}:
{
  flake.modules.nixos.system-users = { self, config, lib, pkgs, stateVersion, ... }: {
    users.groups = {
      "ubridge".name = "ubridge";
      "i2c".name = "i2c";
    };

    users.users."${config.environment.sysConf.user.name}" = {
      initialPassword = "${config.environment.sysConf.user.name}";
      uid = 1000;
      isNormalUser = true;
      linger = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "podman"
        "libvirtd"
        "ubridge"
        "wireshark"
        "dialout"
        "i2c"
      ];
    };

    environment.etc.u2f_mappings.text = lib.mkAfter ''
      ${config.environment.sysConf.user.name}:${config.environment.sysConf.user.yubikeyU2F}
    '';

    users.users."guest" = {
      uid = 1001;
      isNormalUser = true;
      password = "guest";
    };

    home-manager = {
      sharedModules = [ self.modules.homeManager.base ];
      extraSpecialArgs = {
        inherit stateVersion;
        inherit (config.environment.sysConf) gui;
        inherit pkgs;
      };
    };

    home-manager.users = {
      "${config.environment.sysConf.user.name}" = { ... }: {
        home.username = config.environment.sysConf.user.name;

        programs.git.settings.user = {
          name = config.environment.sysConf.git.username;
          email = config.environment.sysConf.git.email;
        };
      };

      "guest" = { ... }: {
        home.username = "guest";
      };
    };
  };
}
