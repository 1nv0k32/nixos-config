{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnome-network-displays
    gnome-terminal
    dconf-editor
    gnome-tweaks
    file-roller
    gnome-calculator
    evolution
    gnome-calendar
  ];

  services = {
    gnome = {
      core-apps.enable = true;
      gnome-keyring.enable = true;
    };
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
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

  hardware = {
    graphics.enable = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber.extraConfig."11-bluetooth-policy" = {
      "wireplumber.settings" = {
        "bluetooth.autoswitch-to-headset-profile" = false;
      };
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
