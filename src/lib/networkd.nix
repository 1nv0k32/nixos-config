{ lib, ... }:
{
  networking = {
    useNetworkd = lib.mkDefault true;
    useDHCP = lib.mkForce false;
  };
  systemd.network = {
    enable = lib.mkDefault true;
    wait-online.enable = false;
  };
}
