{
  self,
  ...
}:
{
  imports = [
    (import ./options.nix)
    (import ./lib/nix.nix)
  ];

  system = {
    stateVersion = self.nixosModules.stateVersion;
  };

}
