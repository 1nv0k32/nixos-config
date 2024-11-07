{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    gnome-network-displays
    gnome.gnome-terminal
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnome.file-roller
    gnome.gnome-calculator
    gnome.geary
    gnome.gnome-calendar
  ];

  services = {
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
        gdm = {
          enable = true;
          autoSuspend = false;
          wayland = true;
        };
      };
    };
    displayManager = {
      defaultSession = "gnome";
    };
  };

  networking.networkmanager.enable = true;

  programs = {
    dconf.enable = true;
  };

  hardware.pulseaudio.enable = lib.mkForce false;
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
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
