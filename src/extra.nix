{ pkgs, lib, ... }:
{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = lib.mkForce false;
        consoleMode = "max";
      };
    };
  };

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
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
