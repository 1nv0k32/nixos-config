{ ... }:
{
  services = {
    avahi = {
      enable = false;
      nssmdns4 = true;
      openFirewall = true;
    };
    resolved = {
      enable = true;
      dnsovertls = "opportunistic";
      dnssec = "no";
      llmnr = "no";
      fallbackDns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      extraConfig = ''
        [Resolve]
        MulticastDNS=yes
        Cache=no
        CacheFromLocalhost=no
        DNSStubListener=yes
      '';
    };
  };
}
