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
    (import ./libs/nix.nix)
  ];

  boot = {
    blacklistedKernelModules = [ "snd_pcsp" ];
    loader = {
      timeout = 0;
    };
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
  };

  services = {
    resolved = {
      enable = true;
      dnsovertls = "opportunistic";
      dnssec = "false";
      fallbackDns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      llmnr = "true";
      extraConfig = customConfigs.RESOLVED_CONFIG;
    };
  };

  programs = {
    dconf.enable = true;
    ssh.extraConfig = customConfigs.SSH_CLIENT_CONFIG;
    fzf = {
      keybindings = true;
      fuzzyCompletion = true;
    };
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
      enableSSHSupport = true;
    };
  };
}
