{ lib, pkgs, config, options, ... }:
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

    hostName = mkOption {
      type = types.str;
      default = "nyx";
      description = "The hostname of the system";
    };

    stateVersion = mkOption {
      type = types.str;
      default = "23.11";
      description = "The version of the system state";
    };
  };

  config = { };
}

# vim:expandtab ts=2 sw=2

