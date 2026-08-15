{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.host-nyxprl = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.nixvim.nixosModules.nixvim
      inputs.disko.nixosModules.disko
      inputs.nixos-generators.nixosModules.all-formats
      self.modules.nixos.roles-core
      self.modules.nixos.roles-base
      self.modules.nixos.roles-development
      self.modules.nixos.roles-security
      self.modules.nixos.hardware-parallels
    ];

    networking.hostName = "nyxprl";

    networking.domain = null;
  };
}
