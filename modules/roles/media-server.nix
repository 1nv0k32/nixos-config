{ ... }:
{
  flake.modules.nixos.roles-media-server = { self, ... }: {
    imports = [
      self.modules.nixos.services-media-server
    ];
  };
}
