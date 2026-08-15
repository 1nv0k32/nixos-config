{
  lib,
  pkgs,
  ...
}:
{
  flake.modules.nixos.programs-kube = { lib, pkgs, ... }: {
    environment.shellAliases = {
      k = "${lib.getExe pkgs.kubectl}";
    };

    programs = {
      kubeswitch.enable = true;
    };
  };
}
