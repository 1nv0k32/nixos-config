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
  };

  virtualisation = {
    libvirtd = {
      enable = true;
    };
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  programs = {
    mtr.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
    winbox = {
      enable = true;
      openFirewall = true;
      package = pkgs.pkgs-unstable.winbox;
    };
  };
}
