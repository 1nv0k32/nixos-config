{
  self,
  lib,
  ...
}:
{
  imports = [
    (import ./libs/options.nix)
    (import ./libs/nix.nix)
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
      VAGRANT_DEFAULT_PROVIDER = lib.mkForce "libvirt";
      LIBVIRT_DEFAULT_URI = lib.mkForce "qemu:///system";
    };
  };
}
