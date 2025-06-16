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
          system = {
            stateVersion = self.stateVersion;
          };
        };
    };
  };
}
