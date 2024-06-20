{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  customConfigs = (import ./configs.nix { inherit inputs pkgs lib; });
in
with lib;
{
  boot = {
    blacklistedKernelModules = mkDefault [ "snd_pcsp" ];
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
      extraConfig = customConfigs.SYSTEMD_CONFIG;
    };
  };

  networking = {
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

  services = {
    avahi.enable = mkForce false;
    fstrim.enable = mkDefault true;
    fprintd.enable = mkDefault true;
    fwupd.enable = mkDefault true;
    resolved = {
      enable = mkDefault true;
      extraConfig = customConfigs.RESOLVED_CONFIG;
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
        login = {
          fprintAuth = mkDefault true;
          # rules.auth.fprintd.order = config.security.pam.services.login.rules.auth.unix.order + 10;
        };
        gdm-fingerprint = {
          fprintAuth = mkDefault true;
        };
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

  programs = {
    mtr.enable = mkDefault true;
    steam.enable = mkDefault true;
    wireshark = {
      enable = mkDefault true;
      package = mkDefault pkgs.wireshark;
    };
  };
}

# vim:expandtab ts=2 sw=2
