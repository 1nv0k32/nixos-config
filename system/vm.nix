{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/virtualisation/qemu-vm.nix") ];

  virtualisation = {
    useBootLoader = true;
    diskSize = 200 * 1024;
  };
}
