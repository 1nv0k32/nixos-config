{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/virtualisation/qemu-vm.nix") ];

  virtualisation = {
    useBootLoader = true;
    cores = 8;
    memorySize = 16 * 1024;
    diskSize = 200 * 1024;
  };
}
