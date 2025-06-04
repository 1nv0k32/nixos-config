{ ... }:
{
  imports = [
    (import ./disko.nix)
    (import ../../modules/wg_server.nix)
  ];

  environment.etc."nixos/flake.nix" = {
    source = ../../flakes/flake.nix;
    mode = "hardlink";
  };

  networking = {
    useNetworkd = true;
    useDHCP = false;
  };
}
