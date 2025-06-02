{ ... }:
{
  imports = [
    (import ../modules/wg_server.nix)
  ];

  boot = {
    initrd.systemd.enable = true;
  };

  networking = {
    useNetworkd = true;
    useDHCP = false;
  };
}
