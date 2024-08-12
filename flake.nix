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
      system = "x86_64-linux";
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
        inputs.nixpkgs.lib.lists.forEach nix_paths (
          p: (inputs.nixpkgs.lib.optionals (builtins.pathExists p) (import p))
        );
      systemTypes = {
        z13g2 = prop: {
          system = self.system;
          specialArgs = {
            stateVersion = self.stateVersion;
            hostName = prop.hostName;
          };
          modules =
            self.baseModules
            ++ [
              inputs.nixos-hardware.nixosModules.lenovo-thinkpad-z13-gen2
              (import "${self}/system/z13g2.nix")
            ]
            ++ prop.modules;
        };
      };
    };
}
