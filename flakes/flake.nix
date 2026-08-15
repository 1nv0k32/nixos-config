{
  inputs = {
    cfg.url = "github:1nv0k32/nixos-config";
    nixpkgs.follows = "cfg/nixpkgs";
    nix-darwin.follows = "cfg/nix-darwin";
  };

  outputs =
    {
      self,
      cfg,
      nixpkgs,
      nix-darwin,
      ...
    }:
    let
      lib = nixpkgs.lib;
      commonArgs = {
        self = cfg;
        inputs = cfg.lib.inputs;
        stateVersion = cfg.lib.stateVersion;
      };
      localModules = builtins.concatLists (
        lib.lists.forEach [
          ./hardware-configuration.nix
          ./local.nix
        ] (path: lib.optional (builtins.pathExists path) (import path))
      );
      mkNixos =
        host: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = commonArgs;
          modules = [
            { system.stateVersion = cfg.lib.stateVersion; }
            cfg.modules.nixos."host-${host}"
          ]
          ++ localModules;
        };
    in
    {
      nixosConfigurations = {
        nyx = mkNixos "nyx" "x86_64-linux";
        nyxpi = mkNixos "nyxpi" "aarch64-linux";
        nyxmac = mkNixos "nyxmac" "aarch64-linux";
        nyxdroid = mkNixos "nyxdroid" "aarch64-linux";
        nyxwsl = mkNixos "nyxwsl" "x86_64-linux";
        nyxvm = mkNixos "nyxvm" "x86_64-linux";
        nyxutm = mkNixos "nyxutm" "aarch64-linux";
        nyxprl = mkNixos "nyxprl" "aarch64-linux";
      };

      darwinConfigurations.nyxdarwin = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = commonArgs;
        modules = [
          cfg.modules.darwin."host-nyxdarwin"
          ./local.nix
        ];
      };
    };
}
