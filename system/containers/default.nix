{ self, ... }:
{
  containers = {
    server01 = {
      config =
        { ... }:
        {
          imports = [
            (import "${self}/modules/k3s.nix")
          ];
          stateVersion = self.stateVersion;
        };
    };
  };
}
