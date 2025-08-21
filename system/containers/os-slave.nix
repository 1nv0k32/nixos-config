{ self, openstack-nix, ... }:
{
  imports = [
    openstack-nix.nixosModules.computeModule
  ];

  system = {
    stateVersion = self.nixosModules.stateVersion;
  };
}
