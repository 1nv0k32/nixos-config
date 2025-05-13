{
  inputs = {
    # nixpkgs
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-24.05";
    # tools
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, ... }@inputs:
    let
      stateVersion = "24.11";
      mainModules = [
        inputs.sops-nix.nixosModules.sops
        inputs.nixos-generators.nixosModules.all-formats
        inputs.home-manager.nixosModules.home-manager
        inputs.nixvim.nixosModules.nixvim
        (import "${self}/pkgs/overlays.nix" { inherit inputs; })
        (import "${self}/modules")
        (import "${self}/src")
      ];
      baseModules = mainModules ++ [
        (import "${self}/src/base.nix")
        (import "${self}/pkgs/base.nix")
      ];
    in
    {
      # Definitions
      optionalLocalModules =
        nix_paths:
        builtins.concatLists (
          inputs.nixpkgs.lib.lists.forEach nix_paths (
            path: inputs.nixpkgs.lib.optional (builtins.pathExists path) (import path)
          )
        );

      systemTypes = {
        # Thinkpad Z13 Gen2
        z13g2 = prop: {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            stateVersion = stateVersion;
            hostName = prop.hostName;
          };
          modules =
            [
              inputs.nixos-hardware.nixosModules.lenovo-thinkpad-z13-gen2
              (import "${self}/system/z13g2.nix")
              (import "${self}/overrides/initrd-luks.nix")
              (import "${self}/src/extra.nix")
              (import "${self}/pkgs/extra.nix")
              (import "${self}/modules/gui")
            ]
            ++ baseModules
            ++ prop.modules;
        };
        # WSL-NixOS
        wsl = prop: {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            stateVersion = stateVersion;
            hostName = prop.hostName;
          };
          modules =
            [
              inputs.nixos-wsl.nixosModules.wsl
              (import "${self}/system/wsl.nix")
            ]
            ++ baseModules
            ++ prop.modules;
        };
        # Raspberry Pi 5
        rpi5 = prop: {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
            stateVersion = stateVersion;
            hostName = prop.hostName;
          };
          modules =
            [
              inputs.nixos-hardware.nixosModules.raspberry-pi-5
              (import "${self}/system/rpi5.nix")
            ]
            ++ baseModules
            ++ prop.modules;
        };
        # Hetzner
        hetzner = prop: {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            stateVersion = stateVersion;
            hostName = prop.hostName;
          };
          modules =
            [
              inputs.disko.nixosModules.disko
              (import "${self}/system/hetzner.nix")
            ]
            ++ baseModules
            ++ prop.modules;
        };
      };

      # DevShells
      devShells =
        let
          system = "x86_64-linux";
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          kernelShells = (import "${self}/shells/kernel.nix" { inherit pkgs; });
          defaultShell = (import "${self}/shells/default.nix" { inherit pkgs; });
        in
        {
          ${system} = {
            default = defaultShell.default;
            kernelEnv = kernelShells.kernelEnv;
          };
        };
    };
}
