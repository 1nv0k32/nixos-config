{ self, ... }:
{
  containers = {
    server01 = {
      config =
        { ... }:
        {
          # stateVersion = self.stateVersion;
          imports = [
            (import "${self}/modules/k3s.nix")
          ];
        };
    };
  };
}
