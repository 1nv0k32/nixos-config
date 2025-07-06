{
  inputs = {
    # nixpkgs
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-test.url = "github:1nv0k32/nixpkgs";
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
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hardware
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
        (import "${self}/system/containers")
      ];
      guiModules = extraModules ++ [
        (import "${self}/modules/gui")
      ];

      # Definitions
      optionalLocalModules =
        nix_paths:
        builtins.concatLists (
          nixpkgs.lib.lists.forEach nix_paths (
            path: nixpkgs.lib.optional (builtins.pathExists path) (import path)
          )
        );
    in
    {
      stateVersion = "25.05";
      systemArch = {
        amd = "x86_64-linux";
        arm = "aarch64-linux";
      };
      systemTypes = {
        # Thinkpad Z13 Gen2
        z13g2 =
          attrs:
          nixpkgs.lib.nixosSystem {
            system = self.systemArch.amd;
            specialArgs = {
              inherit self;
              inherit (attrs) hostName;
            };
            modules =
              [
                nixos-hardware.nixosModules.lenovo-thinkpad-z13-gen2
                (import "${self}/system/z13g2.nix")
              ]
              ++ guiModules
              ++ optionalLocalModules attrs.modules;
          };
        # Hetzner
        hetzner.amd =
          attrs:
          nixpkgs.lib.nixosSystem {
            system = self.systemArch.amd;
            specialArgs = {
              inherit self;
              inherit (attrs) hostName;
            };
            modules =
              [
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
            system = self.systemArch.arm;
            specialArgs = {
              inherit self;
              inherit (attrs) hostName;
            };
            modules =
              [
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
            system = self.systemArch.amd;
            specialArgs = {
              inherit self;
              inherit (attrs) hostName;
            };
            modules =
              [
                nixos-wsl.nixosModules.wsl
                (import "${self}/system/wsl.nix")
              ]
              ++ baseModules
              ++ optionalLocalModules attrs.modules;
          };
        # VM
        vm =
          attrs:
          nixpkgs.lib.nixosSystem {
            system = self.systemArch.amd;
            specialArgs = {
              inherit self;
              inherit (attrs) hostName;
            };
            modules =
              [
                (import "${self}/system/vm.nix")
              ]
              ++ extraModules
              ++ optionalLocalModules attrs.modules;
          };
        # Raspberry Pi 5
        rpi5 =
          attrs:
          nixpkgs.lib.nixosSystem {
            system = self.systemArch.arm;
            specialArgs = {
              inherit self;
              inherit (attrs) hostName;
            };
            modules =
              [
                (import "${self}/system/server.nix")
                (import "${self}/system/rpi5")
              ]
              ++ defaultModules
              ++ optionalLocalModules attrs.modules;
          };
        # UTM
        utm =
          attrs:
          nixpkgs.lib.nixosSystem {
            system = self.systemArch.arm;
            specialArgs = {
              inherit self;
              inherit (attrs) hostName;
            };
            modules =
              [
                (import "${self}/system/utm")
              ]
              ++ guiModules
              ++ optionalLocalModules attrs.modules;
          };
        # Parallels
        parallels =
          attrs:
          nixpkgs.lib.nixosSystem {
            system = self.systemArch.arm;
            specialArgs = {
              inherit self;
              inherit (attrs) hostName;
            };
            modules =
              [
                (import "${self}/system/parallels")
              ]
              ++ extraModules
              ++ optionalLocalModules attrs.modules;
          };
      };

      # DevShells
      devShells = {
        ${self.systemArch.amd} =
          let
            pkgs = nixpkgs.legacyPackages.${self.systemArch.amd};
            defaultShell = (import "${self}/shells/default.nix" { inherit pkgs; });
            kernelShells = (import "${self}/shells/kernel.nix" { inherit pkgs; });
          in
          {
            default = defaultShell.default;
            kernelEnv = kernelShells.kernelEnv;
          };
        ${self.systemArch.arm} =
          let
            pkgs = nixpkgs.legacyPackages.${self.systemArch.arm};
            defaultShell = (import "${self}/shells/default.nix" { inherit pkgs; });
          in
          {
            default = defaultShell.default;
          };
      };
    };
}
