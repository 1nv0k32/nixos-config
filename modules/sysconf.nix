{
  lib,
  pkgs,
  config,
  options,
  ...
}:
with lib;
let
  cfg = config.environment.sysConf;
in
{
  options.environment.sysConf = {
    mainUser = mkOption {
      type = types.str;
      default = "rick";
      description = "The main user of the system";
    };

    gitUserName = mkOption {
      type = types.str;
      default = "Rick Sanchez";
      description = "The name to use for git commits";
    };

    gitEmail = mkOption {
      type = types.str;
      default = "Rick.Sanchez@Wabalaba.dubdub";
      description = "The email to use for git commits";
    };
  };

  config = { };
}

# vim:expandtab ts=2 sw=2
