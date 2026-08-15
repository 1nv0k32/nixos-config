{
  pkgs,
  ...
}:
{
  flake.modules.nixos.programs-waydroid = { pkgs, ... }: {
    virtualisation.waydroid = {
      enable = true;
      package = pkgs.waydroid-nftables;
    };
  };
}
