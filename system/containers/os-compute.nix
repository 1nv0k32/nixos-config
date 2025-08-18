{ openstack-nix, ... }:
{
  imports = [
    openstack-nix.nixosModules.computeModule
  ];
  system = {
    stateVersion = "24.11";
  };
}
