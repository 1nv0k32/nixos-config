{
  lib,
  ...
}:
{
  flake.modules.nixos.hardware-dummy = { lib, ... }: {
    fileSystems."/" = lib.mkDefault {
      device = "none";
      fsType = "ext4";
    };
  };
}
