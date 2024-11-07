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
    fprintd.enable = true;
    fwupd.enable = true;
    pcscd.enable = true;
  };

  security = {
    pam = {
      services = {
        login.fprintAuth = false;
        gdm-fingerprint.fprintAuth = true;
        gdm.enableGnomeKeyring = true;
      };
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
    };
    vmware.host.enable = true;
    podman = {
      enable = true;
      dockerCompat = false;
      defaultNetwork.settings.dns_enabled = true;
    };
    docker.enable = true;
  };

  programs = {
    kubeswitch.enable = true;
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
