{ ... }:
{
  containers = {
    server01 = {
      config =
        { ... }:
        {
          imports = [
            (import ../../modules/k3s.nix)
          ];
        };
    };
  };
}
