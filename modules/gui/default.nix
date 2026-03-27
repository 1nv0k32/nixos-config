{ ... }:
{
  imports = [
    ./pkgs.nix
    ./xdg.nix
    ./chromium.nix
    ./gnome.nix
    ./gns3.nix
    ./localsend.nix
    ./winbox.nix
    ./wireshark.nix
    ./steam.nix
    ./appimage.nix
  ];

  environment.sysConf.gui.enable = true;
  programs.dconf.enable = true;
  services.flatpak.enable = true;
}
