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
      localModules = cfg.localModules { dir = "."; };
      nyxCfg = cfg.systemTypes.z13g2 // {
        specialArgs = cfg.systemTypes.z13g2.specialArgs // {
          hostName = "nyx";
        };
        modules = cfg.systemTypes.z13g2.modules ++ localModules;
      };
    in
    {
      nixosConfigurations = {
        "nyx" = lib.nixosSystem nyxCfg;
      };
    };
}
