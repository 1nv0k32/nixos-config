{
  inputs = {
    cfg = {
      url = "github:1nv0k32/nixos-config/main";
    };
  };

  outputs =
    { cfg, ... }@inputs:
    let
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
    in
    {
      nixosConfigurations = {
        "nyx" = cfg.inputs.nixpkgs.lib.nixosSystem cfg.systemTypes.z13g2 // {
          specialArgs = cfg.systemTypes.z13g2.specialArgs // {
            hostName = "nyx";
          };
          modules = localModules;
        };
      };
    };
}
