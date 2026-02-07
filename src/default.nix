{
  self,
  ...
}:
{
  imports = [
    (import ./lib/nix.nix)
    (import ./options.nix)
  ];

  system = {
    stateVersion = self.nixosModules.stateVersion;
  };

}
