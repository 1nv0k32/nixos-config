{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  services = {
    connman = {
      enable = true;
    };
  };
}
