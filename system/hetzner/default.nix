{ lib, ... }:
{
  imports = [
    (import ./disko.nix)
    (import ../../modules/wg_server.nix)
  ];

  boot.initrd.systemd.enable = lib.mkForce false;
  networking = {
    useNetworkd = true;
    useDHCP = false;
  };
}
