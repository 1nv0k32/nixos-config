{
  stateVersion,
  config,
  lib,
  ...
}:
let
  cfg = config.environment.sysConf;
in
{
  options.environment.sysConf = {
    user = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "rick";
        description = "The main user of the system";
      };
    };

    git = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "Armin Mahdilou";
        description = "The name to use for git commits";
      };

      email = lib.mkOption {
        type = lib.types.str;
        default = "Armin.Mahdilou@gmail.com";
        description = "The email to use for git commits";
      };

      gpgPubKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "01BE96FB0000FC4AF5587CC5E452EB7AAB80DE7B";
        description = "The default gpg to use for git signing";
      };
    };
  };

  config = {
    users.groups."ubridge" = {
      name = "ubridge";
    };

    users.users."${cfg.user.name}" = {
      initialPassword = "${cfg.user.name}";
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
      ];
    };

    users.users."guest" = {
      uid = 1001;
      isNormalUser = true;
      password = "guest";
    };

    home-manager = {
      sharedModules = [ (import ../home/base.nix) ];
      extraSpecialArgs = {
        inherit stateVersion;
      };
    };

    home-manager.users = {
      "${cfg.user.name}" =
        { ... }:
        {
          home.username = cfg.user.name;

          programs.git = {
            userName = cfg.git.username;
            userEmail = cfg.git.email;
            signing = lib.mkIf (cfg.git.gpgPubKey != null) {
              key = cfg.git.gpgPubKey;
            };
          };
        };

      "guest" =
        { ... }:
        {
          home.username = "guest";
        };
    };
  };
}
