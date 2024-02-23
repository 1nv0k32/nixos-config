{ config, pkgs, lib, ... }:
let
  customConfs = pkgs.callPackage (import ./confs.nix) { };
  customPkgs = pkgs.callPackage (import ./pkgs.nix) { };
in
with lib;
{
  imports = [
    (import ./users.nix { inherit customPkgs; })
  ];

  nix = {
    settings.experimental-features = mkDefault [ "nix-command" "flakes" ];
    extraOptions = customConfs.NIX_CONFIG;
  };

  documentation.nixos.enable = mkDefault false;

  system = {
    stateVersion = config.environment.sysConf.stateVersion;
    autoUpgrade = {
      enable = mkDefault true;
      allowReboot = mkDefault false;
      operation = mkDefault "boot";
      flags = mkDefault [ "--upgrade-all" ];
    };
  };

  boot = {
    blacklistedKernelModules = mkDefault [ "snd_pcsp" ];
    extraModprobeConfig = mkDefault "options kvm_amd nested=1";
    loader = {
      efi.canTouchEfiVariables = mkDefault true;
      timeout = mkDefault 0;
      systemd-boot = {
        enable = mkDefault true;
        editor = mkForce false;
        consoleMode = mkDefault "max";
      };
    };
    initrd.systemd = {
      enable = mkDefault true;
      extraConfig = customConfs.SYSTEMD_CONFIG;
    };
  };

  networking = {
    hostName = config.environment.sysConf.hostName;
    networkmanager = {
      enable = mkDefault true;
      dns = mkDefault "systemd-resolved";
      extraConfig = customConfs.NETWORK_MANAGER_CONFIG;
    };
    firewall = {
      enable = mkDefault true;
      checkReversePath = mkDefault false;
      allowPing = mkDefault false;
      allowedTCPPorts = mkDefault [ ];
      allowedUDPPorts = mkDefault [ ];
    };
  };

  systemd = {
    extraConfig = customConfs.SYSTEMD_CONFIG;
    user.extraConfig = customConfs.SYSTEMD_USER_CONFIG;
  };

  time = {
    timeZone = mkDefault "CET";
    hardwareClockInLocalTime = mkDefault false;
  };

  i18n.defaultLocale = mkDefault "en_GB.UTF-8";

  console = {
    earlySetup = mkDefault true;
    packages = customPkgs.CONSOLE;
    font = mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v24b.psf.gz";
    keyMap = mkDefault "us";
  };

  services = {
    avahi.enable = mkForce false;
    gnome = {
      core-utilities.enable = mkForce false;
      gnome-keyring.enable = mkDefault true;
    };
    fstrim.enable = mkDefault true;
    fwupd.enable = mkDefault true;
    resolved = {
      enable = mkDefault true;
      extraConfig = customConfs.RESOLVED_CONFIG;
    };
    logind = {
      killUserProcesses = mkDefault true;
      suspendKeyLongPress = mkDefault "lock";
      suspendKey = mkDefault "lock";
      rebootKeyLongPress = mkDefault "lock";
      rebootKey = mkDefault "lock";
      powerKeyLongPress = mkDefault "lock";
      powerKey = mkDefault "lock";
      hibernateKeyLongPress = mkDefault "lock";
      hibernateKey = mkDefault "lock";
      lidSwitchExternalPower = mkDefault "lock";
      lidSwitchDocked = mkDefault "lock";
      lidSwitch = mkDefault "suspend";
      extraConfig = customConfs.LOGIND_CONFIG;
    };
    xserver = {
      enable = mkDefault true;
      layout = mkDefault "us";
      desktopManager = {
        gnome.enable = mkDefault true;
        wallpaper.mode = "center";
      };
      displayManager = {
        gdm.enable = mkDefault true;
        defaultSession = mkDefault "gnome";
      };
    };
    pipewire = {
      enable = mkDefault true;
      alsa.enable = mkDefault true;
      alsa.support32Bit = mkDefault true;
      pulse.enable = mkDefault true;
    };
  };

  sound.enable = mkDefault true;
  hardware = {
    opengl.driSupport32Bit = mkDefault true;
    pulseaudio.enable = mkForce false;
    bluetooth.powerOnBoot = mkDefault false;
    wirelessRegulatoryDatabase = mkDefault true;
  };

  security = {
    rtkit.enable = mkDefault true;
    pam = {
      services = {
        gdm.enableGnomeKeyring = mkDefault true;
      };
    };
    wrappers.ubridge = {
      source = mkDefault "${pkgs.ubridge}/bin/ubridge";
      capabilities = mkDefault "cap_net_admin,cap_net_raw=ep";
      owner = mkDefault "root";
      group = mkDefault "ubridge";
      permissions = mkDefault "u+rx,g+x";
    };
  };

  virtualisation = {
    podman = {
      enable = mkDefault true;
      dockerCompat = mkDefault false;
      defaultNetwork.settings.dns_enabled = mkDefault true;
    };
    docker.enable = true;
    libvirtd = {
      enable = mkDefault true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = mkDefault true;
    };
  };

  environment = {
    systemPackages = customPkgs.SYSTEM;
    variables = {
      VAGRANT_DEFAULT_PROVIDER = mkForce "libvirt";
      LIBVIRT_DEFAULT_URI = mkForce "qemu:///system";
    };

    etc = {
      "inputrc".text = customConfs.INPUTRC_CONFIG;
      "bashrc.local".text = customConfs.BASHRC_CONFIG;
    };
  };

  programs = {
    neovim = {
      enable = mkDefault true;
      defaultEditor = mkDefault true;
      viAlias = mkDefault true;
      vimAlias = mkDefault true;
    };
    gnupg.agent = {
      enable = mkDefault true;
      pinentryFlavor = mkDefault "curses";
      enableSSHSupport = mkDefault true;
    };
    ssh.extraConfig = customConfs.SSH_CLIENT_CONFIG;
    dconf.enable = mkDefault true;
    tmux = {
      enable = mkDefault true;
      extraConfig = customConfs.TMUX_CONFIG;
    };
    git = {
      enable = mkDefault true;
      config = {
        init.defaultBranch = mkDefault "main";
        color.ui = mkDefault "auto";
        push.autoSetupRemote = mkDefault true;
        push.default = mkDefault "current";
        pull.rebase = mkDefault true;
        fetch.prune = mkDefault true;
        fetch.pruneTags = mkDefault true;
        alias.acommit = mkDefault "commit --amend --no-edit --all";
        alias.fpush = mkDefault "push --force-with-lease";
        rerere.enabled = mkDefault true;
      };
    };
    mtr.enable = mkDefault true;
    steam.enable = mkDefault true;
    wireshark = {
      enable = mkDefault true;
      package = mkDefault pkgs.wireshark;
    };
  };

  fonts = {
    packages = customPkgs.FONT;
    enableDefaultPackages = mkDefault true;
    fontconfig.defaultFonts = {
      serif = mkDefault [ "Vazirmatn" "DejaVu Serif" ];
      sansSerif = mkDefault [ "Vazirmatn" "DejaVu Sans" ];
    };
  };
}

# vim:expandtab ts=2 sw=2
