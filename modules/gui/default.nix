{ pkgs, ... }:
{
  imports = [
    ./pkgs.nix
    ./xdg.nix
    ./chromium.nix
    ./gnome.nix
    ./gns3.nix
    ./localsend.nix
    ./winbox.nix
    ./steam.nix
  ];

  programs = {
    dconf.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };
}
