{ lib, ... }:
{
  imports = [
    (import ./disko.nix)
  ];

  boot = {
    binfmt.emulatedSystems = lib.mkForce [ ];
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
