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
        Cache=false
        CacheFromLocalhost=false
        DNSStubListener=false
      '';
    };
  };
}
