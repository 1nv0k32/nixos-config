{ self, openstack-nix, ... }:
{
  imports = [
    (import ./base.nix { inherit self; })
    openstack-nix.nixosModules."x86_64-linux".controllerModule
  ];
}
