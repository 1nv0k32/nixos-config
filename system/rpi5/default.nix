{
  self,
  ...
}:
{
  imports = [
    (import ./disko.nix)
    (import "${self}/modules/etc/media.nix")
  ];

  users.users.root.initialPassword = "root";

  boot.loader.raspberry-pi.bootloader = "kernel";
}
