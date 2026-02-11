{ ... }:
{
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    resolved = {
      enable = true;
      fallbackDns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
  };
}
