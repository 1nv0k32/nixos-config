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
        host: attrib:
        attrib.systemType {
          hostName = host;
          domain = attrib.domain;
          modules = [
            ./hardware-configuration.nix
            ./local.nix
          ];
        };
    in
    {
      nixosConfigurations = builtins.mapAttrs mkHost {
        nyx = {
          domain = "nyxlan.net";
          systemType = systemTypes.z13g2;
        };
        nyxpi = {
          domain = "nyxlan.net";
          systemType = systemTypes.rpi5;
        };
        nyxmac = {
          domain = null;
          systemType = systemTypes.mac;
        };
        nyxdroid = {
          domain = null;
          systemType = systemTypes.avf;
        };
        nyxhub = {
          domain = null;
          systemType = systemTypes.hetzner.amd;
        };
        nyxarm = {
          domain = null;
          systemType = systemTypes.hetzner.arm;
        };
        nyxwsl = {
          domain = null;
          systemType = systemTypes.wsl;
        };
        nyxvm = {
          domain = null;
          systemType = systemTypes.qemu;
        };
        nyxutm = {
          domain = null;
          systemType = systemTypes.utm;
        };
        nyxprl = {
          domain = null;
          systemType = systemTypes.parallels;
        };
      };
      darwinConfigurations = builtins.mapAttrs mkHost {
        nyxdarwin = {
          domain = null;
          systemType = systemTypes.darwin;
        };
      };
    };
}
