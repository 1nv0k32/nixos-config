{ self, ... }:
{
  imports = [
    (import ./disko.nix)
    (import "${self}/modules/wg_server.nix")
  ];

  networking = {
    useNetworkd = true;
    useDHCP = false;
  };
}
