{
  lib,
  ...
}:
{
  imports = [
    (import ./disko.nix)
  ];

  users.users.root.initialPassword = "root";

  boot.loader.raspberry-pi.bootloader = "kernel";
}
