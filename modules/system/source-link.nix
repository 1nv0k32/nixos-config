{
  self,
  ...
}:
{
  flake.modules.nixos.system-source-link = { self, ... }: {
    environment = {
      etc = {
        "nixos/flake.nix" = {
          source = "${self}/flakes/flake.nix";
          mode = "0444";
        };
      };
    };
  };
}
