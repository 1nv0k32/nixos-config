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
      localPaths =
        nix_paths: lib.lists.forEach nix_paths (p: (lib.optionals (builtins.pathExists p) (import p)));
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
              ++ (localPaths [
                ./hardware-configuration.nix
                ./local.nix
              ]);
          }
        );
      };
    };
}
