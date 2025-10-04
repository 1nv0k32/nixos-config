{ self, ... }:
{
  imports = [
    (import ./disko.nix)
    (import "${self}/modules/etc/wg_server.nix")
  ];

  networking = {
    useNetworkd = true;
    useDHCP = false;
  };
}
