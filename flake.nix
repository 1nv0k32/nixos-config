{
  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
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

  outputs = { self, ... }@inputs: {
    stateVersion = "24.05";
    system = "x86_64-linux";
    baseModules = [
      (
        { lib, ... }: {
          imports = [ ]
            ++ lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix
            ++ lib.optional (builtins.pathExists ./local.nix) ./local.nix;
        }
      )
      (import "${self}/src")
      (import "${self}/modules")
      "${self}/pkgs/base.nix"
    ];
  };
}

