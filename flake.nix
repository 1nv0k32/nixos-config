{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
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
      localModules = dir: [
        (
          { lib, ... }:
          {
            imports =
              [ ]
              ++ lib.optional (builtins.pathExists "${dir}/hardware-configuration.nix") (
                import ${dir}/hardware-configuration.nix
              )
              ++ lib.optional (builtins.pathExists "${dir}/local.nix") (import ${dir}/local.nix);
          }
        )
      ];
      systemTypes = {
        z13g2 = {
          system = "x86_64-linux";
          specialArgs = {
            inherit (self) stateVersion inputs;
          };
          modules = self.baseModules ++ [
            inputs.nixos-hardware.nixosModules.lenovo-thinkpad-z13-gen2
            (import "${self}/system/z13.nix")
          ];
        };
      };
    };
}
