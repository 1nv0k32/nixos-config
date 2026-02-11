{ lib, ... }:
{
  networking.firewall.allowedUDPPorts = [
    53
    5353
  ];
  services = {
    avahi.enable = lib.mkForce true;
    resolved = {
      enable = true;
      dnsovertls = "false";
      dnssec = "false";
      llmnr = "true";
      fallbackDns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      extraConfig = ''
        [Resolve]
        MulticastDNS=true
        Cache=false
        CacheFromLocalhost=false
        DNSStubListener=false
      '';
    };
  };
}
