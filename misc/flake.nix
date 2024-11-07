{
  inputs = {
    cfg = {
      url = "github:1nv0k32/nixos-config";
    };
  };

  outputs =
    { cfg, ... }:
    {
      nixosConfigurations = {
        nyx = cfg.inputs.nixpkgs.lib.nixosSystem (
          cfg.systemTypes.z13g2 {
            hostName = "nyx";
            modules = cfg.optionalLocalModules [
              ./hardware-configuration.nix
              ./local.nix
            ];
          }
        );
        arminix = cfg.inputs.nixpkgs.lib.nixosSystem (
          cfg.systemTypes.wsl {
            hostName = "arminix";
            modules = cfg.optionalLocalModules [
              ./hardware-configuration.nix
              ./local.nix
            ];
          }
        );
        nyxpi = cfg.inputs.nixpkgs.lib.nixosSystem (
          cfg.systemTypes.rpi5 {
            hostName = "nyxpi";
            modules = cfg.optionalLocalModules [
              ./hardware-configuration.nix
              ./local.nix
            ];
          }
        );
      };
    };
}
