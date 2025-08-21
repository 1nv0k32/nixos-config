{ self, openstack-nix, ... }:
{
  imports = [
    openstack-nix.nixosModules."x86_64-linux".controllerModule
  ];

  networking.extraHosts = ''
    127.0.0.1 controller controller.local
  '';

  system = {
    stateVersion = self.nixosModules.stateVersion;
  };
}
