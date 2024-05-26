{
  inputs,
  stateVersion,
  hostName,
  config,
  pkgs,
  lib,
  ...
}:
let
  customConfs = (import ./confs.nix) { inherit inputs pkgs lib; };
in
with lib;
{
  imports = [ (import ./users.nix) ];

  nix = {
    settings.experimental-features = mkDefault [
      "nix-command"
      "flakes"
    ];
  };

  documentation.nixos.enable = mkDefault false;

  system = {
    stateVersion = stateVersion;
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
    hostName = hostName;
    networkmanager = {
      enable = mkDefault true;
      dns = mkDefault "systemd-resolved";
      settings = {
        main = {
          no-auto-default = "*";
          systemd-resolved = true;
        };
      };
    };
    firewall = {
      enable = mkDefault true;
      checkReversePath = mkDefault false;
      allowPing = mkDefault false;
      allowedTCPPorts = mkDefault [ ];
      allowedTCPPortRanges = mkDefault [ ];
      allowedUDPPorts = mkDefault [ ];
      allowedUDPPortRanges = mkDefault [ ];
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
    packages = with pkgs; [ terminus_font ];
    font = mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v24b.psf.gz";
    keyMap = mkDefault "us";
  };

  services = {
    pcscd.enable = mkDefault true;
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
    logind =
      let
        defaultAction = "lock";
      in
      {
        lidSwitch = mkDefault "suspend";
        lidSwitchDocked = mkDefault defaultAction;
        lidSwitchExternalPower = mkDefault defaultAction;
        suspendKey = mkDefault defaultAction;
        suspendKeyLongPress = mkDefault defaultAction;
        rebootKey = mkDefault defaultAction;
        rebootKeyLongPress = mkDefault defaultAction;
        powerKey = mkDefault defaultAction;
        powerKeyLongPress = mkDefault defaultAction;
        hibernateKey = mkDefault defaultAction;
        hibernateKeyLongPress = mkDefault defaultAction;
        killUserProcesses = mkDefault true;
        extraConfig = customConfs.LOGIND_CONFIG;
      };
    xserver = {
      enable = mkDefault true;
      xkb.layout = mkDefault "us";
      desktopManager = {
        gnome.enable = mkDefault true;
        wallpaper.mode = mkDefault "center";
      };
      displayManager = {
        gdm.enable = mkDefault true;
      };
    };
    displayManager = {
      defaultSession = mkDefault "gnome";
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
    variables = {
      VAGRANT_DEFAULT_PROVIDER = mkForce "libvirt";
      LIBVIRT_DEFAULT_URI = mkForce "qemu:///system";
    };

    etc = {
      "inputrc".text = customConfs.INPUTRC_CONFIG;
      "bashrc.local".text = customConfs.BASHRC_CONFIG;
      "wireplumber/policy.lua.d/99-bluetooth-policy.lua".text = mkDefault ''
        bluetooth_policy.policy["media-role.use-headset-profile"] = false
      '';
    };
  };

  programs = {
    neovim = {
      enable = mkDefault true;
      defaultEditor = mkDefault true;
      viAlias = mkDefault true;
      vimAlias = mkDefault true;
      configure = {
        customRC = customConfs.VIMRC_CONFIG;
      };
    };
    gnupg.agent = {
      enable = mkDefault true;
      pinentryPackage = mkDefault pkgs.pinentry-curses;
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
    kubeswitch.enable = mkDefault true;
  };

  fonts = {
    packages = with pkgs; [
      ubuntu_font_family
      vazir-fonts
    ];
    enableDefaultPackages = mkDefault true;
    fontconfig.defaultFonts = {
      serif = mkDefault [
        "Vazirmatn"
        "DejaVu Serif"
      ];
      sansSerif = mkDefault [
        "Vazirmatn"
        "DejaVu Sans"
      ];
    };
  };
}

# vim:expandtab ts=2 sw=2
