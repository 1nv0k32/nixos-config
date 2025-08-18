{ openstack-nix, system, ... }:
{
  imports = [
    openstack-nix.nixosModules.${system}.controllerModule
  ];
  system = {
    stateVersion = "24.11";
  };
}
