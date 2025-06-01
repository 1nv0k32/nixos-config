{
  inputs = {
    cfg = {
      url = "github:1nv0k32/nixos-config";
    };
  };

  outputs =
    { cfg, ... }:
    let
      mkHost = host: systemType: systemType {
        hostName = host;
        modules = cfg.optionalLocalModules [
          ./hardware-configuration.nix
          ./local.nix
        ];
      };
    in
    {
      nixosConfigurations = {
        mapAttrs mkHost {
          nyx = cfg.systemTypes.z13g2;
        };
        nyxvm = cfg.systemTypes.vm {
          hostName = "nyxvm";
          modules = cfg.optionalLocalModules [
            ./hardware-configuration.nix
            ./local.nix
          ];
        };
        nyxwsl = cfg.systemTypes.wsl {
          hostName = "arminix";
          modules = cfg.optionalLocalModules [
            ./hardware-configuration.nix
            ./local.nix
          ];
        };
        nyxpi = cfg.systemTypes.rpi5 {
          hostName = "nyxpi";
          modules = cfg.optionalLocalModules [
            ./hardware-configuration.nix
            ./local.nix
          ];
        };
        hub = cfg.systemTypes.hetzner {
          hostName = "hub";
          modules = cfg.optionalLocalModules [
            ./hardware-configuration.nix
            ./local.nix
          ];
        };
      };
    };
}
