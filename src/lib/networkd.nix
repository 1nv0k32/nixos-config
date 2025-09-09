{ lib, ... }:
{
  systemd.network = {
    enable = lib.mkDefault true;
    wait-online.enable = false;
  };
}
