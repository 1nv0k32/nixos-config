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
    in
    {
      nixosConfigurations = {
        "nyx" = lib.nixosSystem (
          cfg.systemTypes.z13g2
          // {
            specialArgs = cfg.systemTypes.z13g2.specialArgs // {
              hostName = "nyx";
            };
            modules =
              cfg.systemTypes.z13g2.modules
              ++ (cfg.optionalLocalModules [
                ./hardware-configuration.nix
                ./local.nix
              ]);
          }
        );
      };
    };
}
