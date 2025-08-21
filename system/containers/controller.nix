{
  openstack-nix,
  ...
}@attrs:
{
  imports = [
    (import ./base.nix attrs)
    openstack-nix.nixosModules."x86_64-linux".controllerModule
  ];
}
