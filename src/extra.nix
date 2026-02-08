{
  lib,
  ...
}:
{

  boot = {
    consoleLogLevel = 0;
    plymouth.enable = true;
    initrd.verbose = false;
    loader = {
      efi.canTouchEfiVariables = lib.mkDefault true;
      timeout = lib.mkDefault 0;
      systemd-boot = {
        enable = lib.mkDefault true;
        editor = lib.mkForce false;
        consoleMode = lib.mkDefault "max";
      };
    };
    kernelParams = lib.mkAfter [
      "quiet"
      "splash"
      "udev.log_level=3"
    ];
  };

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    printing.enable = true;
    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", TAG+="uaccess"
    '';
  };

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
}
