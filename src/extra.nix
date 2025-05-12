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
    initrd.systemd.enable = true;
    binfmt.emulatedSystems = [
      "x86_64-windows"
      "aarch64-linux"
    ];
  };

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    pcscd.enable = true;
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
      dockerCompat = false;
      defaultNetwork.settings.dns_enabled = true;
    };
    docker.enable = true;
  };

  programs = {
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };
}
