{
  inputs,
  modulesPath,
  ...
}:
{
  flake.modules.nixos.hardware-utm = { modulesPath, ... }: {
    imports = [
      "${modulesPath}/profiles/qemu-guest.nix"
    ];

    boot = {
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

    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/vda";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted";
                  askPassword = true;
                  postCreateHook = ''
                    systemd-cryptenroll \
                      --fido2-device auto \
                      --fido2-with-user-verification no \
                      --fido2-with-user-presence no \
                      /dev/disk/by-partlabel/disk-main-root
                  '';
                  content = {
                    type = "filesystem";
                    format = "ext4";
                    mountpoint = "/";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
