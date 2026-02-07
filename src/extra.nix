{
  self,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    (import ./users.nix)
  ];

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
  };

  programs = {
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };

  environment = {
    etc = {
      "nixos/flake.nix" = {
        source = "${self}/flakes/flake.nix";
        mode = "0444";
      };
    };
    variables = {
      LIBVIRT_DEFAULT_URI = lib.mkForce "qemu:///system";
    };
  };
}
