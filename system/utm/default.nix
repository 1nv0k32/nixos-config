{ lib, ... }:
{
  imports = [
    (import ./disko.nix)
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.grub.devices = lib.mkDefault [ "/dev/vda" ];
    initrd.kernelModules = [ "virtio_gpu" ];
    growPartition = true;
  };

  fileSystems."/" = lib.mkDefault {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  networking.useNetworkd = true;
  networking.useDHCP = false;

  services.qemuGuest.enable = lib.mkDefault true;
}
