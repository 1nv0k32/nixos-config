{ lib, modulesPath, ... }: {
  imports = [
    (modulesPath + "/profiles/all-hardware.nix")
  ];

  boot.loader.efi.canTouchEfiVariables = false;
}

# vim:expandtab ts=2 sw=2

