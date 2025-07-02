{ modulesPath, ... }:
{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    (import ./disko.nix)
  ];

  boot = {
    growPartition = true;
    initrd.kernelModules = [
      "virtio_gpu"
      "virtio_pci"
      "xhci_pci"
      "usb_storage"
      "usbhid"
    ];
  };

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
  };
}
