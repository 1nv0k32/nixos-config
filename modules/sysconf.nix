{ lib, ... }:
{
  options.environment.sysConf = {
    mainUser = lib.mkOption {
      type = lib.types.str;
      default = "rick";
      description = "The main user of the system";
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

    postfixSaslPasswordPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "The postfix sasl password file path";
    };
  };

  config = { };
}
