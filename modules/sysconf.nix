{ lib, pkgs, config, options, ... }:
with lib;
let
  cfg = config.sysConf;
in
{
  options.sysConf = {
    mainUser = mkOption {
      type = types.str;
      default = "rick";
      description = "The main user of the system";
    };
  };

  config = { };
}

# vim:expandtab ts=2 sw=2

