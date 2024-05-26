{ 
  pkgs,
  ...
}:
with pkgs;
{
  gnomeExtensions = [
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    gnomeExtensions.tiling-assistant
    gnomeExtensions.caffeine
    gnomeExtensions.unblank
  ];
}

# vim:expandtab ts=2 sw=2
