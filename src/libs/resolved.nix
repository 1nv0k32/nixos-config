{ customConfigs, ... }:
{
  services.resolved = {
    enable = true;
    dnsovertls = "opportunistic";
    dnssec = "false";
    fallbackDns = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    llmnr = "true";
    extraConfig = customConfigs.RESOLVED_CONFIG;
  };
}
