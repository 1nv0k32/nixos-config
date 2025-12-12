{
  inputs = {
    # nixpkgs
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-test.url = "github:1nv0k32/nixpkgs";
    # tools
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
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
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    openstack-nix = {
      url = "github:cobaltcore-dev/openstack-nix";
    };
    openstack-nix-dev = {
      url = "github:1nv0k32/openstack-nix";
    };
    # hardware
    nixos-avf.url = "github:nix-community/nixos-avf";
    nixos-avf-dev.url = "github:1nv0k32/nixos-avf";
    nixos-mac = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    srvos = {
      url = "github:nix-community/srvos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    { self, ... }@inputs:
    with inputs;
    let
      # Modules
      defaultModules = [
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        disko.nixosModules.disko
        nixos-generators.nixosModules.all-formats
        nixvim.nixosModules.nixvim
        (import "${self}/pkgs/overlays.nix" inputs)
        (import "${self}/modules")
        (import "${self}/src")
      ];
      baseModules = defaultModules ++ [
        (import "${self}/src/base.nix")
        (import "${self}/pkgs/base.nix")
      ];
      extraModules = baseModules ++ [
        (import "${self}/overrides/initrd-luks.nix")
        (import "${self}/src/extra.nix")
        (import "${self}/pkgs/extra.nix")
      ];
      guiModules = extraModules ++ [
        (import "${self}/modules/gui")
      ];

      # Definitions
      systems = {
        x86_64-linux = "x86_64-linux";
        aarch64-linux = "aarch64-linux";
      };
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      optionalLocalModules =
        nix_paths:
        builtins.concatLists (
          nixpkgs.lib.lists.forEach nix_paths (
            path: nixpkgs.lib.optional (builtins.pathExists path) (import path)
          )
        );
    in
    {
      nixosModules = {
        stateVersion = "25.05";
        systemTypes = {
          # Thinkpad Z13 Gen2
          z13g2 =
            attrs:
            nixpkgs.lib.nixosSystem {
              system = systems.x86_64-linux;
              specialArgs = {
                inherit self openstack-nix;
                inherit (attrs) hostName;
              };
              modules = [
                nixos-hardware.nixosModules.lenovo-thinkpad-z13-gen2
                (import "${self}/system/z13g2")
              ]
              ++ guiModules
              ++ optionalLocalModules attrs.modules;
            };
          # Mac
          mac =
            attrs:
            nixpkgs.lib.nixosSystem {
              system = systems.aarch64-linux;
              specialArgs = {
                inherit self;
                inherit (attrs) hostName;
              };
              modules = [
                nixos-mac.nixosModules.apple-silicon-support
                (import "${self}/system/mac")
              ]
              ++ guiModules
              ++ optionalLocalModules attrs.modules;
            };
          # AVF
          avf =
            attrs:
            nixpkgs.lib.nixosSystem {
              system = systems.aarch64-linux;
              specialArgs = {
                inherit self;
                inherit (attrs) hostName;
              };
              modules = [
                nixos-avf.nixosModules.avf
                (import "${self}/system/server.nix")
                (import "${self}/system/avf")
              ]
              ++ baseModules
              ++ optionalLocalModules attrs.modules;
            };
          # Hetzner
          hetzner.amd =
            attrs:
            nixpkgs.lib.nixosSystem {
              system = systems.x86_64-linux;
              specialArgs = {
                inherit self;
                inherit (attrs) hostName;
              };
              modules = [
                srvos.nixosModules.hardware-hetzner-cloud
                (import "${self}/system/server.nix")
                (import "${self}/system/hetzner")
              ]
              ++ baseModules
              ++ optionalLocalModules attrs.modules;
            };
          hetzner.arm =
            attrs:
            nixpkgs.lib.nixosSystem {
              system = systems.aarch64-linux;
              specialArgs = {
                inherit self;
                inherit (attrs) hostName;
              };
              modules = [
                srvos.nixosModules.hardware-hetzner-cloud-arm
                (import "${self}/system/server.nix")
                (import "${self}/system/hetzner")
              ]
              ++ baseModules
              ++ optionalLocalModules attrs.modules;
            };
          # WSL-NixOS
          wsl =
            attrs:
            nixpkgs.lib.nixosSystem {
              system = systems.x86_64-linux;
              specialArgs = {
                inherit self;
                inherit (attrs) hostName;
              };
              modules = [
                nixos-wsl.nixosModules.wsl
                (import "${self}/system/wsl")
              ]
              ++ baseModules
              ++ optionalLocalModules attrs.modules;
            };
          # Raspberry Pi 5
          rpi5 =
            attrs:
            nixpkgs.lib.nixosSystem {
              system = systems.aarch64-linux;
              specialArgs = {
                inherit self;
                inherit (attrs) hostName;
              };
              modules = [
                nixos-hardware.nixosModules.raspberry-pi-5
                (import "${self}/system/server.nix")
                (import "${self}/system/rpi5")
              ]
              ++ extraModules
              ++ optionalLocalModules attrs.modules;
            };
          # QEMU
          qemu =
            attrs:
            nixpkgs.lib.nixosSystem {
              system = systems.x86_64-linux;
              specialArgs = {
                inherit self;
                inherit (attrs) hostName;
              };
              modules = [
                (import "${self}/system/qemu.nix")
                # (import "${self}/system/containers")
              ]
              ++ extraModules
              ++ optionalLocalModules attrs.modules;
            };
          # UTM
          utm =
            attrs:
            nixpkgs.lib.nixosSystem {
              system = systems.aarch64-linux;
              specialArgs = {
                inherit self;
                inherit (attrs) hostName;
              };
              modules = [
                (import "${self}/system/qemu.nix")
                (import "${self}/system/utm")
              ]
              ++ guiModules
              ++ optionalLocalModules attrs.modules;
            };
          # Parallels
          parallels =
            attrs:
            nixpkgs.lib.nixosSystem {
              system = systems.aarch64-linux;
              specialArgs = {
                inherit self;
                inherit (attrs) hostName;
              };
              modules = [
                (import "${self}/system/parallels")
              ]
              ++ extraModules
              ++ optionalLocalModules attrs.modules;
            };
        };
      };

      formatter = forAllSystems (system: (import nixpkgs { inherit system; }).nixfmt-tree);

      devShells = forAllSystems (
        system:
        let
          pkgs = (import nixpkgs { inherit system; });
          defaultShells = (import "${self}/shells/default.nix" { inherit pkgs; });
          kernelShells = (import "${self}/shells/kernel.nix" { inherit pkgs; });
          pythonShells = (import "${self}/shells/python.nix" { inherit pkgs; });
          goShells = (import "${self}/shells/go.nix" { inherit pkgs; });
        in
        {
          default = defaultShells.shell;
          kernel = kernelShells.shell;
          python = pythonShells.shell;
          go = goShells.shell;
        }
      );
    };
}
