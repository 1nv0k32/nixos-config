{
  self,
  hostName,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    (import ./users.nix)
    (import ./lib/systemd.nix)
    (import ./lib/logind.nix)
    (import ./lib/networking.nix)
  ];

  boot = {
    tmp.cleanOnBoot = true;
    blacklistedKernelModules = [ "snd_pcsp" ];
  };

  networking = {
    hostName = hostName;
  };

  hardware = {
    enableAllFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    wirelessRegulatoryDatabase = true;
  };

  programs = {
    kubeswitch.enable = true;
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
