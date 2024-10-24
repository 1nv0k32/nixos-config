{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, ... }@inputs:
    {
      stateVersion = "24.05";
      baseModules = [
        inputs.home-manager.nixosModules.home-manager
        inputs.nixvim.nixosModules.nixvim
        (import "${self}/pkgs/overlays.nix" { inherit inputs; })
        (import "${self}/modules")
        (import "${self}/src/base.nix")
        (import "${self}/pkgs/base.nix")
      ];
      optionalLocalModules =
        nix_paths:
        builtins.concatLists (
          inputs.nixpkgs.lib.lists.forEach nix_paths (
            path: inputs.nixpkgs.lib.optional (builtins.pathExists path) (import path)
          )
        );
      systemTypes = {
        z13g2 = prop: {
          system = "x86_64-linux";
          specialArgs = {
            stateVersion = self.stateVersion;
            hostName = prop.hostName;
          };
          modules =
            self.baseModules
            ++ [
              inputs.nixos-hardware.nixosModules.lenovo-thinkpad-z13-gen2
              (import "${self}/system/z13g2.nix")
              (import "${self}/overrides/initrd-luks.nix")
              (import "${self}/src/extra.nix")
              (import "${self}/pkgs/extra.nix")
            ]
            ++ prop.modules;
        };
        rpi5 = prop: {
          system = "aarch64-linux";
          specialArgs = {
            stateVersion = self.stateVersion;
            hostName = prop.hostName;
          };
          modules =
            self.baseModules
            ++ [
              inputs.raspberry-pi-nix.nixosModules.raspberry-pi
              (import "${self}/system/rpi5.nix")
            ]
            ++ prop.modules;
        };
      };
    };
}
