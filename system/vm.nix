{
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/virtualisation/qemu-vm.nix") ];
  services.qemuGuest.enable = true;

  virtualisation = {
    diskSize = 50 * 1024;
  };
}
