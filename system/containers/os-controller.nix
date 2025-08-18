{ openstack-nix, ... }:
{
  imports = [
    openstack-nix.nixosModules."x86_64-linux".controllerModule
  ];
  system = {
    stateVersion = "24.11";
  };
}
