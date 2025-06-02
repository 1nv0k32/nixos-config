{ ... }:
{
  imports = [
    (import ../modules/wg_server.nix)
  ];

  networking = {
    useNetworkd = true;
    useDHCP = false;
  };
}
