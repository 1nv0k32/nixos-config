{
  self,
  ...
}:
{
  imports = [
    (import ./lib/options.nix)
    (import ./lib/nix.nix)
  ];

  system = {
    stateVersion = self.nixosModules.stateVersion;
  };
}
