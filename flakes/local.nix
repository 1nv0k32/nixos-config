{ lib, ... }:
{
  fileSystems."/" = lib.mkDefault {
    device = "none";
  };
}
