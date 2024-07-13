{
  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, home-manager, ... }@inputs:
    {
      stateVersion = "24.05";
      system = "x86_64-linux";
      baseModules = [
        home-manager.nixosModules.home-manager
        (import "${self}/modules")
        (import "${self}/src/base.nix")
        (import "${self}/pkgs/base.nix")
      ];
    };
}

# vim:expandtab ts=2 sw=2
