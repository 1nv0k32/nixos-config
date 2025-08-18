{ openstack-nix, ... }:
{
  imports = [
    openstack-nix.nixosModules."x86_64-linux".computeModule
  ];
  system = {
    stateVersion = "24.11";
  };
}
