{
  inputs = {
    cfg = {
      url = "github:1nv0k32/nixos-config";
    };
  };

  outputs =
    { cfg, ... }:
    with cfg.nixosModules;
    let
      mkHost =
        host: systemType:
        systemType {
          hostName = host;
          modules = [
            ./hardware-configuration.nix
            ./local.nix
          ];
        };
    in
    {
      nixosConfigurations = builtins.mapAttrs mkHost {
        nyx = systemTypes.z13g2;
        nyxhub = systemTypes.hetzner.amd;
        nyxarm = systemTypes.hetzner.arm;
        nyxwsl = systemTypes.wsl;
        nyxvm = systemTypes.qemu;
        nyxutm = systemTypes.utm;
        nyxprl = systemTypes.parallels;
      };
    };
}
