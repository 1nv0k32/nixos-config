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
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    resolved = {
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
        Cache=no
        CacheFromLocalhost=no
        DNSStubListener=yes
      '';
    };
  };
}
