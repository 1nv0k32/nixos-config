{
  stateVersion,
  config,
  lib,
  ...
}:
let
  mainUser = config.environment.sysConf.mainUser;
in
{
  options = {
    environment.sysConf = {
      mainUser = lib.mkOption {
        type = lib.types.str;
        default = "rick";
        description = "The main user of the system";
      };

      mainUserSSHKey = lib.mkOption {
        type = lib.types.str;
        default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJ414vPwc8EjJPtKSGTSUCWuSQNifNI3pv+/sodmkAd8Ww6ofCxPcrJ1UjgTXis2Oqk2I1EGtRnD2ozom+jW+AZ5R00Ht2+1RGD+dkd0rrIqi+HFEVFPUDCu1pAZnLOzfGrFGpHpWkrbDqtv7OFA60g9iIAaId1Fi1VOSR43s4XYmTmWio7R090LW6aENb+jc2vW7VSKq/MlgTtvfKEHm187RFNHf+2BGp8Cdq6rwSEbzkkiQ9kI0W6JxCGRRDf0qIoAu6TVpjoHlzXAEFUZaz4EtxM2EmyhiRop4vVougUqtnRTzq8+RRMoVECXOylJGWbd8MX25MnRbCGph7UXuZ8sGrvwsJBjbDhWRuIgYfJdnf+ymuki361F8qIvBC7xHsBGVfEpVXcGuSC9GaBw8Y3XLMBtpcUXfuT1Tz1O/U+QwC5mdAgGwZ2BQkBfP8edtpeg5LkSgcU7F4LPaXAEnzievqljyS4UUV0vqF/2iTM72q8wlM5XO7GsWkY7/B6g/Ha3080yypUza9lG20CAaeCso4CsjehF3qd4S4BcZeXUpaOUYHYk6f2M/QEReAY1viJAsx4o6dQ2sArg8JM/5IWBRWzM/NK+RrPvCWzk8lmsMBEaKkPWEpBe7H07qbOn2fDDBQxL0ImoGdXtqLNH7lOZGYZVKbZZ5ZknZB4EeIKQ== rick@nyx";
        description = "The main user's trusted SSH key";
      };

      gitUserName = lib.mkOption {
        type = lib.types.str;
        default = "Armin Mahdilou";
        description = "The name to use for git commits";
      };

      gitEmail = lib.mkOption {
        type = lib.types.str;
        default = "Armin.Mahdilou@gmail.com";
        description = "The email to use for git commits";
      };

      gitGpgKey = lib.mkOption {
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

    users.users."${mainUser}" = {
      initialPassword = "${mainUser}";
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
  };
}
