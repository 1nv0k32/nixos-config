{ self, openstack-nix, ... }:
{
  imports = [
    openstack-nix.nixosModules."x86_64-linux".computeModule
  ];

  system = {
    stateVersion = self.nixosModules.stateVersion;
  };
}
