{ ... }:
{
  imports = [
    (import ./disko.nix)
    (import ../../modules/wg_server.nix)
  ];

  networking = {
    useNetworkd = true;
    useDHCP = false;
  };
}
