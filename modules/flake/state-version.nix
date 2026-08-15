{ lib, ... }:
{
  options.flake = {
    stateVersion = lib.mkOption {
      type = lib.types.str;
      default = "26.05";
      description = "Default stateVersion used by NixOS, nix-darwin, and home-manager configurations.";
    };
  };
}
