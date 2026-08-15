{
  inputs,
  ...
}:
{
  flake.modules.nixos.hardware-z13g2 = { ... }: {
    imports = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-z13-gen2
    ];

    boot = {
      extraModprobeConfig = ''
        options kvm_amd nested=1
      '';
      binfmt.emulatedSystems = [
        "x86_64-windows"
        "aarch64-linux"
      ];
    };

    hardware = {
      alsa.enablePersistence = true;
    };

    environment.variables = {
      "VDPAU_DRIVER" = "radeonsi";
      "LIBVA_DRIVER_NAME" = "radeonsi";
    };

    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/nvme0n1";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                label = "ESP";
                size = "5G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              root = {
                label = "root";
                size = "500G";
                content = {
                  type = "luks";
                  name = "root";
                  askPassword = true;
                  content = {
                    type = "filesystem";
                    format = "ext4";
                    mountpoint = "/";
                  };
                };
              };
              home = {
                label = "home";
                size = "250G";
                content = {
                  type = "luks";
                  name = "home";
                  askPassword = true;
                  content = {
                    type = "filesystem";
                    format = "ext4";
                    mountpoint = "/home";
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
