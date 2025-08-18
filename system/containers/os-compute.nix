{ openstack-nix, system, ... }:
{
  imports = [
    openstack-nix.nixosModules.${system}.computeModule
  ];
  system = {
    stateVersion = "24.11";
  };
}
