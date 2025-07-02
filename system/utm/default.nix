{ lib, ... }:
{
  imports = [
    (import ./disko.nix)
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.kernelModules = [
      "virtio_gpu"
      "virtio_pci"
      "xhci_pci"
      "usb_storage"
      "usbhid"
    ];
    growPartition = true;
  };

  networking.useNetworkd = true;
  networking.useDHCP = false;

  services.qemuGuest.enable = lib.mkDefault true;
}
