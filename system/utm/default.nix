{ modulesPath, ... }:
{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    (import ./disko.nix)
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

  virtualisation.rosetta.enable = true;

  services = {
    spice-vdagentd.enable = true;
  };
}
