{ self, ... }:
{
  imports = [
    (import "${self}/modules/k3s.nix")
  ];
  system = {
    stateVersion = self.stateVersion;
  };
}
