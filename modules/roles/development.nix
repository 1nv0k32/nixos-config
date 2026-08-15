{ ... }:
{
  flake.modules.nixos.roles-development = { self, ... }: {
    imports = [
      self.modules.nixos.programs-kube
      self.modules.nixos.system-virtualization
      self.modules.nixos.packages-development
    ];
  };
}
