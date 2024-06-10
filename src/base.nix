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
  customConfigs = (import ./configs.nix { inherit inputs pkgs lib; });
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

  networking = {
    hostName = hostName;
  };

  systemd = {
    watchdog = {
      runtimeTime = "off";
      rebootTime = "off";
      kexecTime = "off";
    };
    extraConfig = customConfigs.SYSTEMD_CONFIG;
    user.extraConfig = customConfigs.SYSTEMD_USER_CONFIG;
  };

  time = {
    timeZone = mkDefault "CET";
    hardwareClockInLocalTime = mkDefault false;
  };

  i18n.defaultLocale = mkDefault "en_GB.UTF-8";

  console = {
    earlySetup = mkDefault true;
    packages = [ pkgs.terminus_font ];
    font = mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v24b.psf.gz";
    keyMap = mkDefault "us";
  };

  services = {
    pcscd.enable = mkDefault true;
    gnome = {
      core-utilities.enable = mkForce false;
      gnome-keyring.enable = mkDefault true;
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
        extraConfig = customConfigs.LOGIND_CONFIG;
      };
  };

  security = {
    pam = {
      services = {
        gdm.enableGnomeKeyring = mkDefault true;
      };
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
      "inputrc".text = customConfigs.INPUTRC_CONFIG;
      "bashrc.local".text = customConfigs.BASHRC_CONFIG;
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
        customRC = customConfigs.VIMRC_CONFIG;
      };
    };
    gnupg.agent = {
      enable = mkDefault true;
      pinentryPackage = mkDefault pkgs.pinentry-curses;
      enableSSHSupport = mkDefault true;
    };
    ssh.extraConfig = customConfigs.SSH_CLIENT_CONFIG;
    dconf.enable = mkDefault true;
    tmux = {
      enable = mkDefault true;
      extraConfig = customConfigs.TMUX_CONFIG;
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
