{ self, ... }:
{
  containers = {
    server01 = {
      autoStart = true;
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
