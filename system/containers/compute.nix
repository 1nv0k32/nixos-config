{ ... }@attrs:
{
  imports = [
    (import ./base.nix attrs)
    attrs.openstack-nix.nixosModules."x86_64-linux".computeModule
  ];

  systemd.network = {
    networks."10-eth0" = {
      address = [ "10.0.1.101/24" ];
    };
  };
}
