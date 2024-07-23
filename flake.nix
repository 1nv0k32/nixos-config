{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/2405.5.4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs =
    { self, ... }@inputs:
    let
      system = "x86_64-linux";
      stateVersion = "24.05";
      baseModules = [
        inputs.home-manager.nixosModules.home-manager
        inputs.nixvim.nixosModules.nixvim
        (import "${self}/modules")
        (import "${self}/src/base.nix")
        (import "${self}/pkgs/base.nix")
      ];
    in
    {
      baseSystem = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit stateVersion;
          inherit system;
          inherit inputs;
        };
        modules = baseModules;
      };
    };
}

# vim:expandtab ts=2 sw=2
