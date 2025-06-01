{ lib, pkgs, ... }:
let
  gnomeExtensions = with pkgs.gnomeExtensions; [
    appindicator
    just-perfection
    tiling-assistant
    caffeine
    unblank
    vitals
  ];
in
{
  home.packages = gnomeExtensions;
  dconf.settings = {
    "org/gnome/desktop/sound" = {
      event-sounds = false;
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      clock-show-seconds = true;
      clock-show-weekday = true;
      show-battery-percentage = true;
      enable-hot-corners = false;
    };
    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 300;
    };
    "org/gnome/desktop/background" = {
      picture-options = "none";
      color-shading-type = "solid";
      primary-color = "#000000";
      secondary-color = "#000000";
    };
    "org/gnome/desktop/notifications" = {
      show-in-lock-screen = false;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      click-method = "areas";
      disable-while-typing = true;
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
      middle-click-emulation = true;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      power-button-action = "nothing";
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "suspend";
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
    };
    "org/gnome/desktop/input-sources" = {
      per-window = true;
      sources = [
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "us"
        ])
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "ir"
        ])
      ];
    };
    "org/gnome/desktop/wm/preferences" = {
      audible-bell = false;
      auto-raise = true;
    };
    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = [ "<Super>Print" ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>c" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-applications = [ "<Super>Tab" ];
      activate-window-menu = [ ];
      show-desktop = [ "<Super>d" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      home = [ "<Super>e" ];
      volume-up = [ "<Super>F12" ];
      volume-down = [ "<Super>F11" ];
      volume-mute = [ "<Super>F10" ];
      next = [ "<Control><Super>Right" ];
      play = [ "<Control><Super>Down" ];
      previous = [ "<Control><Super>Left" ];
      stop = [ "<Control><Super>Up" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "gnome-terminal";
      binding = "<Super>Return";
      command = "${pkgs.kitty}/bin/kitty --start-as=maximized";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "suspend";
      binding = "<Super><Shift>S";
      command = "systemctl suspend";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "flameshot";
      binding = "Print";
      command = "script --command ' flameshot gui ' /dev/null";
    };

    # Extensions
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = lib.lists.forEach gnomeExtensions (e: e.extensionUuid);
    };

    "org/gnome/shell/extensions/just-perfection" = {
      animation = lib.hm.gvariant.mkInt32 4;
      panel = true;
      panel-in-overview = true;
      double-super-to-appgrid = false;
      window-demands-attention-focus = true;
      startup-status = lib.hm.gvariant.mkInt32 0;
      osd-position = lib.hm.gvariant.mkInt32 2;
    };

    "org/gnome/shell/extensions/unblank" = {
      power = false;
      time = lib.hm.gvariant.mkInt32 0;
    };

    "org/gnome/shell/extensions/vitals" = {
      fixed-widths = false;
      hide-icons = false;
      hide-zeros = false;
      hot-sensors = [
        "_battery_rate_"
        "_battery_time_left_"
        "_processor_usage_"
        "_processor_frequency_"
        "_system_load_1m_"
        "__fan_avg__"
        "_memory_usage_"
        "_system_uptime_"
      ];
      icon-style = lib.hm.gvariant.mkInt32 1;
      include-public-ip = false;
      menu-centered = true;
      position-in-panel = lib.hm.gvariant.mkInt32 0;
      show-battery = true;
      update-time = lib.hm.gvariant.mkInt32 1;
      use-higher-precision = false;
    };
  };
}
