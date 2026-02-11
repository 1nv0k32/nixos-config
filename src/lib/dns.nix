{ lib, ... }:
{
  networking.firewall.allowedUDPPorts = [
    53
    5353
  ];
  services = {
    avahi.enable = lib.mkForce false;
    resolved = {
      enable = true;
      dnsovertls = "opportunistic";
      dnssec = "allow-downgrade";
      llmnr = "false";
      fallbackDns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      extraConfig = ''
        [Resolve]
        MulticastDNS=true
        Cache=false
        CacheFromLocalhost=false
        DNSStubListener=true
      '';
    };
  };
}
