{ self, openstack-nix, ... }:
{
  imports = [
    openstack-nix.nixosModules."x86_64-linux".controllerModule
  ];

  system = {
    stateVersion = self.nixosModules.stateVersion;
  };
}
