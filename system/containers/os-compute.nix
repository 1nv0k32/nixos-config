{ self, openstack-nix, ... }:
{
  imports = [
    openstack-nix.nixosModules.controllerModule
  ];
  system = {
    stateVersion = self.stateVersion;
  };
}
