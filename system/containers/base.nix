{ self, ... }:
{
  system = {
    stateVersion = self.nixosModules.stateVersion;
  };
}
