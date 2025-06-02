{
  inputs = {
    # nixpkgs
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-24.11";
    # tools
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
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
      stateVersion = "25.05";
      defaultModules = [
        inputs.sops-nix.nixosModules.sops
        inputs.home-manager.nixosModules.home-manager
        inputs.disko.nixosModules.disko
        inputs.nixvim.nixosModules.nixvim
        (import "${self}/pkgs/overlays.nix" inputs)
        (import "${self}/modules")
        (import "${self}/src" { nixpkgs = inputs.nixpkgs; })
      ];
      baseModules = defaultModules ++ [
        (import "${self}/src/base.nix")
        (import "${self}/pkgs/base.nix")
      ];
      extraModules = baseModules ++ [
        (import "${self}/overrides/initrd-luks.nix")
        (import "${self}/src/extra.nix")
        (import "${self}/pkgs/extra.nix")
        (import "${self}/modules/gui")
      ];

      # Definitions
      optionalLocalModules =
        nix_paths:
        builtins.concatLists (
          inputs.nixpkgs.lib.lists.forEach nix_paths (
            path: inputs.nixpkgs.lib.optional (builtins.pathExists path) (import path)
          )
        );
    in
    {

      systemTypes = {
        # Thinkpad Z13 Gen2
        z13g2 =
          attrs:
          inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
              stateVersion = stateVersion;
              hostName = attrs.hostName;
            };
            modules =
              [
                inputs.nixos-hardware.nixosModules.lenovo-thinkpad-z13-gen2
                (import "${self}/system/z13g2.nix")
              ]
              ++ extraModules
              ++ optionalLocalModules attrs.modules;
          };
        # VM
        vm =
          attrs:
          inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
              stateVersion = stateVersion;
              hostName = attrs.hostName;
            };
            modules =
              [
                (import "${self}/system/vm.nix")
              ]
              ++ extraModules
              ++ optionalLocalModules attrs.modules;
          };
        # WSL-NixOS
        wsl =
          attrs:
          inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
              stateVersion = stateVersion;
              hostName = attrs.hostName;
            };
            modules =
              [
                inputs.nixos-wsl.nixosModules.wsl
                (import "${self}/system/wsl.nix")
              ]
              ++ baseModules
              ++ optionalLocalModules attrs.modules;
          };
        # Raspberry Pi 5
        rpi5 =
          attrs:
          inputs.nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            specialArgs = {
              stateVersion = stateVersion;
              hostName = attrs.hostName;
            };
            modules =
              [
                inputs.nixos-hardware.nixosModules.raspberry-pi-5
                (import "${self}/system/rpi5.nix")
              ]
              ++ defaultModules
              ++ optionalLocalModules attrs.modules;
          };
        # Hetzner
        hetzner =
          attrs:
          inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
              stateVersion = stateVersion;
              hostName = attrs.hostName;
            };
            modules =
              [
                (import "${self}/system/hetzner.nix")
              ]
              ++ baseModules
              ++ optionalLocalModules attrs.modules;
          };
      };

      # DevShells
      devShells =
        let
          system = "x86_64-linux";
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          defaultShell = (import "${self}/shells/default.nix" { inherit pkgs; });
          kernelShells = (import "${self}/shells/kernel.nix" { inherit pkgs; });
        in
        {
          ${system} = {
            default = defaultShell.default;
            kernelEnv = kernelShells.kernelEnv;
          };
        };
    };
}
