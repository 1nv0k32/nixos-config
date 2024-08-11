{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  customConfigs = (import ./configs.nix { inherit inputs pkgs lib; });
in
with lib;
{
  boot = {
    blacklistedKernelModules = [ "snd_pcsp" ];
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 0;
      systemd-boot = {
        enable = true;
        editor = mkForce false;
        consoleMode = "max";
      };
    };
    initrd.systemd = {
      enable = true;
      extraConfig = customConfigs.SYSTEMD_CONFIG;
    };
  };

  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      settings = {
        main = {
          no-auto-default = "*";
          systemd-resolved = true;
        };
      };
    };
    firewall = {
      enable = true;
      checkReversePath = false;
      allowPing = false;
      allowedTCPPorts = [ ];
      allowedTCPPortRanges = [ ];
      allowedUDPPorts = [ ];
      allowedUDPPortRanges = [ ];
    };
  };

  systemd = {
    watchdog = {
      runtimeTime = "off";
      rebootTime = "off";
      kexecTime = "off";
    };
  };

  console = {
    earlySetup = true;
    packages = [ pkgs.terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v24b.psf.gz";
    keyMap = "us";
  };

  sound.enable = true;
  services = {
    fstrim.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;
    pcscd.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    gnome = {
      core-utilities.enable = true;
      gnome-keyring.enable = true;
    };
    resolved = {
      enable = true;
      extraConfig = customConfigs.RESOLVED_CONFIG;
    };
    logind =
      let
        defaultAction = "lock";
        suspendAction = "suspend";
      in
      {
        lidSwitch = suspendAction;
        lidSwitchDocked = defaultAction;
        lidSwitchExternalPower = defaultAction;
        suspendKey = defaultAction;
        suspendKeyLongPress = defaultAction;
        rebootKey = defaultAction;
        rebootKeyLongPress = defaultAction;
        powerKey = defaultAction;
        powerKeyLongPress = defaultAction;
        hibernateKey = defaultAction;
        hibernateKeyLongPress = defaultAction;
        killUserProcesses = true;
        extraConfig = customConfigs.LOGIND_CONFIG;
      };
    xserver = {
      enable = true;
      xkb.layout = "us";
      desktopManager = {
        gnome.enable = true;
        wallpaper.mode = "center";
      };
      displayManager = {
        gdm.enable = true;
      };
    };
    displayManager = {
      defaultSession = "gnome";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  hardware = {
    opengl.driSupport32Bit = true;
    pulseaudio.enable = mkForce false;
    bluetooth.powerOnBoot = false;
    wirelessRegulatoryDatabase = true;
  };

  security = {
    rtkit.enable = true;
    pam = {
      services = {
        login.fprintAuth = false;
        gdm-fingerprint.fprintAuth = true;
        gdm.enableGnomeKeyring = true;
      };
    };
    wrappers.ubridge = {
      source = "${pkgs.ubridge}/bin/ubridge";
      capabilities = "cap_net_admin,cap_net_raw=ep";
      owner = "root";
      group = "ubridge";
      permissions = "u+rx,g+x";
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
    };
  };

  programs = {
    mtr.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
    firefox = {
      enable = true;
    };
    winbox = {
      enable = true;
      openFirewall = true;
      package = pkgs.pkgs-unstable.winbox;
    };
  };

  fonts = {
    packages = with pkgs; [
      ubuntu_font_family
      vazir-fonts
      nerdfonts
      (nerdfonts.override { fonts = [ "Noto" ]; })
    ];
    enableDefaultPackages = true;
    fontconfig.defaultFonts = {
      serif = [
        "Vazirmatn"
        "DejaVu Serif"
      ];
      sansSerif = [
        "Vazirmatn"
        "DejaVu Sans"
      ];
    };
  };
}
