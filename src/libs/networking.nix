{ ... }:
{
  networking = {
    networkmanager = {
      dns = "systemd-resolved";
      settings = {
        main = {
          no-auto-default = "*";
          systemd-resolved = true;
        };
      };
    };
    firewall = {
      enable = true;
      checkReversePath = false;
      allowPing = false;
      allowedTCPPorts = [ ];
      allowedTCPPortRanges = [ ];
      allowedUDPPorts = [
        5353 # mDNS
      ];
      allowedUDPPortRanges = [ ];
      trustedInterfaces = [ ];
    };
  };

  services.resolved = {
    enable = true;
    dnsovertls = "opportunistic";
    dnssec = "false";
    fallbackDns = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    llmnr = "true";
    extraConfig = ''
      [Resolve]
      #DNS=
      #Domains=
      MulticastDNS=yes
      Cache=no
      CacheFromLocalhost=no
      DNSStubListener=yes
    '';
  };
}
