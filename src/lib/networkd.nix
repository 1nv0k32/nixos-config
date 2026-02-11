{ lib, ... }:
{
  networking = {
    useNetworkd = lib.mkDefault false;
    useDHCP = lib.mkForce false;
  };

  systemd.network = {
    enable = lib.mkDefault false;
    wait-online.enable = false;
    networks = {
      "99-all" = {
        matchConfig = {
          Name = "*";
        };
        DHCP = "yes";
        extraConfig = ''
          [Network]
          MulticastDNS=true;
        '';
      };
    };
  };
}
