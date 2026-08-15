{ ... }:
{
  flake.modules.nixos.system-virtualization = { ... }: {
    environment.variables = {
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };

    services.fstrim.enable = true;

    virtualisation = {
      libvirtd = {
        enable = true;
      };
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      vmVariant = {
        virtualisation = {
          vmVariantWithBootLoader = true;
          memorySize = 4094;
          cores = 4;
        };
      };
    };
  };
}
