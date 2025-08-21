{ ... }@attrs:
{
  imports = [
    (import ./base.nix attrs)
    attrs.openstack-nix.nixosModules."x86_64-linux".computeModule
  ];
}
