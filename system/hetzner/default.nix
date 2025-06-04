{ ... }:
{
  imports = [
    (import ./disko.nix)
    (import ../../modules/wg_server.nix)
  ];

  environment.etc."nixos/flake.nix" = {
    source = ../../flakes/flake.nix;
    mode = "direct-symlink";
  };

  networking = {
    useNetworkd = true;
    useDHCP = false;
  };
}
