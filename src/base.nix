{
  hostName,
  pkgs,
  ...
}:
{
  imports = [
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
