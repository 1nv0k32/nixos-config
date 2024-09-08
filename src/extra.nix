{
  modulesPath,
  pkgs,
  lib,
  config,
  ...
}:
let
  customConfigs = (import ./configs.nix { inherit modulesPath pkgs lib; });
in
with lib;
{
  boot = {
    initrd.systemd = {
      enable = true;
      extraConfig = customConfigs.SYSTEMD_CONFIG;
    };
    binfmt.emulatedSystems = [
      "x86_64-windows"
      "aarch64-linux"
    ];
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
      trustedInterfaces = [ "lxdbr0" ];
    };
  };

  sound.enable = true;
  services = {
    fstrim.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;
    pcscd.enable = true;
    gnome = {
      core-utilities.enable = true;
      gnome-keyring.enable = true;
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
    pulseaudio.enable = mkForce false;
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
    podman = {
      enable = mkDefault true;
      dockerCompat = mkDefault false;
      defaultNetwork.settings.dns_enabled = mkDefault true;
    };
    docker.enable = mkDefault true;
    lxd = {
      enable = mkDefault true;
      recommendedSysctlSettings = mkDefault true;
    };
  };

  programs = {
    dconf.enable = true;
    kubeswitch.enable = true;
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

  i18n.defaultLocale = "en_GB.UTF-8";

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
