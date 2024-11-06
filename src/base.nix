{
  modulesPath,
  hostName,
  pkgs,
  lib,
  ...
}:
let
  customConfigs = (import ./configs.nix { inherit modulesPath pkgs lib; });
in
{
  imports = [
    (import ./users.nix)
    (import ./libs/logind.nix { inherit customConfigs; })
    (import ./libs/resolved.nix { inherit customConfigs; })
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

  systemd = {
    extraConfig = customConfigs.SYSTEMD_CONFIG;
    enableUnifiedCgroupHierarchy = true;
    watchdog = {
      runtimeTime = "off";
      rebootTime = "off";
      kexecTime = "off";
    };
    user.extraConfig = customConfigs.SYSTEMD_USER_CONFIG;
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

  programs = {
    dconf.enable = true;
  };
}
