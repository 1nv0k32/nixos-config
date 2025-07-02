{ modulesPath, lib, ... }:
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
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = lib.mkForce false;
        consoleMode = "max";
      };
    };
  };

  services.qemuGuest.enable = lib.mkDefault true;
}
