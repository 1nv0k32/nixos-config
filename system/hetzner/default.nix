{ ... }:
{
  imports = [
    (import ./disko.nix)
    (import ../../modules/wg_server.nix)
  ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
  ];

  networking = {
    useNetworkd = true;
    useDHCP = false;
  };
}
