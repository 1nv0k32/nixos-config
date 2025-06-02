{ lib, ... }:
{
  fileSystems."/" = lib.mkForce {
    device = "none";
  };
}
