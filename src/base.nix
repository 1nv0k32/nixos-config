{
  hostName,
  stateVersion,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    (import ./users.nix { inherit stateVersion; })
    (import ./libs/systemd.nix)
    (import ./libs/logind.nix)
    (import ./libs/networking.nix)
    (import ./libs/nix.nix)
  ];

  boot = {
    blacklistedKernelModules = [ "snd_pcsp" ];
    loader = {
      timeout = 0;
    };
  };

  networking = {
    hostName = hostName;
  };

  hardware = {
    enableAllFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    wirelessRegulatoryDatabase = true;
  };

  programs = {
    dconf.enable = true;
    kubeswitch.enable = true;
  };

  security = {
    pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };

  console = {
    earlySetup = true;
    packages = [ pkgs.terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v24b.psf.gz";
    keyMap = "us";
  };

  time = {
    timeZone = "CET";
    hardwareClockInLocalTime = false;
  };

  environment = {
    variables = {
      VAGRANT_DEFAULT_PROVIDER = lib.mkForce "libvirt";
      LIBVIRT_DEFAULT_URI = lib.mkForce "qemu:///system";
    };
  };
}
