{
  nixpkgs,
  nixpkgs-master,
  nixpkgs-unstable,
  nixpkgs-old,
  ...
}:
{
  flake.modules.nixos.packages-overlays = { ... }: {
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };
      overlays = [
        (_: prev: {
          master = import nixpkgs-master {
            inherit (prev.stdenv) system;
            config = {
              allowUnfree = true;
              allowUnsupportedSystem = true;
            };
          };
        })
        (_: prev: {
          unstable = import nixpkgs-unstable {
            inherit (prev.stdenv) system;
            config = {
              allowUnfree = true;
              allowUnsupportedSystem = true;
            };
          };
        })
        (_: prev: {
          old = import nixpkgs-old {
            inherit (prev.stdenv) system;
            config = {
              allowUnfree = true;
              allowUnsupportedSystem = true;
            };
          };
        })
      ];
    };

    environment.variables = {
      NIXPKGS_ALLOW_UNFREE = "1";
    };

    nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
  };
}
