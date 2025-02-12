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
      default = "Rick Sanchez";
      description = "The name to use for git commits";
    };

    gitEmail = lib.mkOption {
      type = lib.types.str;
      default = "Rick.Sanchez@Wabalaba.dubdub";
      description = "The email to use for git commits";
    };

    gitGpgKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The default gpg to use for git signing";
    };
  };

  config = { };
}
