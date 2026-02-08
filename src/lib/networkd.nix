{ lib, ... }:
{
  networking = {
    useNetworkd = lib.mkDefault false;
    useDHCP = lib.mkForce false;
  };

  systemd.network = {
    enable = lib.mkDefault true;
    wait-online.enable = false;
    networks = {
      "*" = {
        DHCP = "yes";
      };
    };
  };
}
