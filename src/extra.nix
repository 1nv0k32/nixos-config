{
  inputs,
  stateVersion,
  hostName,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
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

  services = {
    avahi.enable = mkForce false;
    fstrim.enable = mkDefault true;
    fprintd.enable = mkDefault true;
    fwupd.enable = mkDefault true;
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
        login.fprintAuth = mkDefault false;
        gdm-fingerprint.fprintAuth = mkDefault true;
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
