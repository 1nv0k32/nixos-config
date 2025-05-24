{
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/virtualisation/qemu-vm.nix") ];
  services.qemuGuest.enable = true;

  virtualisation = {
    cores = 4;
    memorySize = 4 * 1024;
    diskSize = 200 * 1024;
  };
}
