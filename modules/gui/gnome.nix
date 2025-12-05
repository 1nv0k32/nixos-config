{ pkgs, config, ... }:
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
    desktopManager = {
      gnome.enable = true;
    };
    displayManager = {
      gdm = {
        enable = true;
        autoSuspend = false;
        wayland = true;
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

  environment.variables.ALSA_CONFIG_UCM2 = "${pkgs.alsa-ucm-conf}/share/alsa/ucm2";
  systemd.user.services.pipewire.environment.ALSA_CONFIG_UCM2 =
    config.environment.variables.ALSA_CONFIG_UCM2;
  systemd.user.services.wireplumber.environment.ALSA_CONFIG_UCM2 =
    config.environment.variables.ALSA_CONFIG_UCM2;

  i18n.defaultLocale = "en_GB.UTF-8";

  fonts = {
    packages = with pkgs; [
      ubuntu-classic
      vazir-fonts
      nerd-fonts.noto
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
