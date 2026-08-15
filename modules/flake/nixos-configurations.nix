{
  inputs,
  self,
  ...
}:
let
  mkNixos =
    name: system:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit self;
        stateVersion = self.lib.stateVersion;
      };
      modules = [
        { system.stateVersion = self.lib.stateVersion; }
        self.modules.nixos.hardware-dummy
        self.modules.nixos."host-${name}"
      ];
    };
in
{
  flake.nixosConfigurations = {
    nyx = mkNixos "nyx" "x86_64-linux";
    nyxpi = mkNixos "nyxpi" "aarch64-linux";
    nyxmac = mkNixos "nyxmac" "aarch64-linux";
    nyxdroid = mkNixos "nyxdroid" "aarch64-linux";
    nyxwsl = mkNixos "nyxwsl" "x86_64-linux";
    nyxvm = mkNixos "nyxvm" "x86_64-linux";
    nyxutm = mkNixos "nyxutm" "aarch64-linux";
    nyxprl = mkNixos "nyxprl" "aarch64-linux";
  };
}
