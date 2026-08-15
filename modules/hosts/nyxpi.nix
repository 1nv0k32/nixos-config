{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.host-nyxpi = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.nixvim.nixosModules.nixvim
      inputs.disko.nixosModules.disko
      inputs.nixos-generators.nixosModules.all-formats
      self.modules.nixos.roles-core
      self.modules.nixos.roles-base
      self.modules.nixos.roles-server
      self.modules.nixos.roles-media-server
      self.modules.nixos.hardware-rpi5
    ];

    networking.hostName = "nyxpi";

    networking.domain = "nyxlan.internal";
  };
}
