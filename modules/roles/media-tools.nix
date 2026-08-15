{ ... }:
{
  flake.modules.nixos.roles-media-tools = { self, ... }: {
    imports = [
      self.modules.nixos.packages-media-tools
    ];
  };
}
