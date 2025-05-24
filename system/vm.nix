{
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/virtualisation/qemu-vm.nix") ];
  services.qemuGuest.enable = true;

  virtualisation = {
    cores = 4;
    memorySize = 8 * 1024;
    diskSize = 200 * 1024;
  };
}
