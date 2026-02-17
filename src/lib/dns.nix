{ ... }:
{
  services = {
    resolved = {
      enable = true;
      fallbackDns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      extraConfig = ''
        [Resolve]
        MulticastDNS=false
        Cache=false
        CacheFromLocalhost=false
        DNSStubListener=false
      '';
    };
  };
}
