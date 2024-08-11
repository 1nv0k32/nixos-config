{
  inputs = {
    cfg = {
      url = "github:1nv0k32/nixos-config/main";
    };
  };

  outputs =
    { cfg, ... }@inputs:
    let
      lib = cfg.inputs.nixpkgs.lib;
      localModules = [
        (
          { lib, ... }:
          {
            imports =
              [ ]
              ++ lib.optional (builtins.pathExists ./hardware-configuration.nix) (import ./hardware-configuration.nix)
              ++ lib.optional (builtins.pathExists ./local.nix) (import ./local.nix);
          }
        )
      ];
      nyxCfg = mkMerge [
        cfg.systemTypes.z13g2
        {
          specialArgs.hostName = "nyx";
          modules = localModules;
        }
      ];
    in
    {
      nixosConfigurations = {
        "nyx" = lib.nixosSystem nyxCfg;
      };
    };
}
