{ ... }:
{
  networking.firewall.allowedUDPPorts = [ 5353 ];
  services = {
    avahi = {
      enable = false;
      nssmdns4 = true;
      openFirewall = true;
    };
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
