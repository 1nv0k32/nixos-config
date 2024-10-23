{
  modulesPath,
  stateVersion,
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
    (import ./libs/git.nix)
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

  system = {
    stateVersion = stateVersion;
  };

  networking = {
    hostName = hostName;
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
      "inputrc".text = customConfigs.INPUTRC_CONFIG;
      "bashrc.local".text = customConfigs.BASHRC_CONFIG;
      "wireplumber/policy.lua.d/99-bluetooth-policy.lua".text = ''
        bluetooth_policy.policy["media-role.use-headset-profile"] = false
      '';
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    resolved = {
      enable = true;
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
