{ modulesPath, ... }:
{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  boot = {
    growPartition = true;
    initrd.kernelModules = [
      "virtio_pci"
      "xhci_pci"
      "usb_storage"
      "usbhid"
    ];
  };

  services = {
    spice-vdagentd.enable = true;
  };
}
