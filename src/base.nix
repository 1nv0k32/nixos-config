{
  hostName,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    (import ./users.nix)
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
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    wirelessRegulatoryDatabase = true;
  };

  programs = {
    dconf.enable = true;
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
    etc = {
      "wireplumber/policy.lua.d/99-bluetooth-policy.lua".text = ''
        bluetooth_policy.policy["media-role.use-headset-profile"] = false
      '';
    };
  };
}
