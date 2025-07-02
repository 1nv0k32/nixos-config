{ lib, ... }:
{
  imports = [
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

  services.qemuGuest.enable = lib.mkDefault true;
}
