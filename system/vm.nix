{
  inputs,
  system,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [
    (import ../src/extra.nix)
    (import ../pkgs/extra.nix)
    (import ../overlays/initrd-luks.nix)
  ];

  services = {
    xserver = {
      modules = [ pkgs.xorg.xf86videofbdev ];
      videoDrivers = [ "hyperv_fb" ];
    };
  };

  virtualisation.hypervGuest.enable = true;
}

# vim:expandtab ts=2 sw=2
