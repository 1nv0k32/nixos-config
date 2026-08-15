{ inputs, ... }:
{
  flake.modules.nixos.packages-overlays = { ... }: {
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };
      overlays = [
        (_: prev: {
          master = import inputs.nixpkgs-master {
            inherit (prev.stdenv) system;
            config = {
              allowUnfree = true;
              allowUnsupportedSystem = true;
            };
          };
        })
        (_: prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            config = {
              allowUnfree = true;
              allowUnsupportedSystem = true;
            };
          };
        })
        (_: prev: {
          old = import inputs.nixpkgs-old {
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

    nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };
}
