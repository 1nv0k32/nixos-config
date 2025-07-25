{
  self,
  lib,
  ...
}:
{
  imports = [
    (import ./libs/nix.nix)
    (import ./options.nix)
    (import ./users.nix)
  ];

  system = {
    stateVersion = self.stateVersion;
  };

  environment = {
    etc = {
      "nixos/flake.nix" = {
        source = "${self}/flakes/flake.nix";
        mode = "0444";
      };
    };
    variables = {
      NIXPKGS_ALLOW_UNFREE = 1;
      LIBVIRT_DEFAULT_URI = lib.mkForce "qemu:///system";
    };
  };
}
