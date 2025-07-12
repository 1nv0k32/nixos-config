{
  hostName,
  pkgs,
  ...
}:
{
  imports = [
    (import ./libs/systemd.nix)
    (import ./libs/logind.nix)
    (import ./libs/networking.nix)
  ];

  boot = {
    tmp.cleanOnBoot = true;
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
}
