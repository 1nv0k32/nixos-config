{ pkgs, lib, ... }:
{
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = lib.mkDefault 0;
      systemd-boot = {
        enable = lib.mkDefault true;
        editor = lib.mkForce false;
        consoleMode = "max";
      };
    };
    kernelParams = lib.mkAfter [
      "quiet"
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
  };

  programs = {
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };
}
