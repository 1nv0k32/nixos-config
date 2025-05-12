{ pkgs, ... }:
{
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 40000;
      to = 50000;
    }
  ];
  programs.winbox = {
    enable = true;
    openFirewall = true;
    package = pkgs.pkgs-unstable.winbox;
  };
}
