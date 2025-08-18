{ openstack-nix, ... }:
{
  imports = [
    openstack-nix.nixosModules.controllerModule
  ];
  system = {
    stateVersion = "24.11";
  };
}
