{ lib, pkgs, ... }:
let
  int32 = lib.hm.gvariant.mkInt32;
  gnomeExtensions = with pkgs.gnomeExtensions; [
    appindicator
    just-perfection
    tiling-assistant
    caffeine
    unblank
    display-configuration-switcher
    # vitals
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
      animation = int32 4;
      panel = true;
      panel-in-overview = true;
      double-super-to-appgrid = false;
      window-demands-attention-focus = true;
      startup-status = int32 0;
      osd-position = int32 2;
    };

    "org/gnome/shell/extensions/unblank" = {
      power = false;
      time = int32 0;
    };

    "org/gnome/shell/extensions/vitals" = {
      fixed-widths = false;
      hide-icons = false;
      hide-zeros = false;
      include-public-ip = false;
      menu-centered = true;
      show-battery = true;
      use-higher-precision = false;
      icon-style = int32 1;
      position-in-panel = int32 0;
      update-time = int32 1;
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
    };

    "org/gnome/shell/extensions/display-configuration-switcher/configs" = [
      "('dual', uint32 3009710084, [(0, 0, 1.0, uint32 0, true, [('DP-10', '3440x1440@59.973', {'underscanning': <false>})]), (3440, 0, 1.0, 0, false, [('DP-2', '1920x1080@59.934', {'underscanning': <false>})])], @a{sv} {}, [('DP-10', 'PHL', 'PHL 346P1C', 'UK02208021981'), ('DP-2', 'LEN', 'LEN T24i-10', 'VNA2MMCV'), ('eDP-1', 'AUO', '0x53ad', '0x00000000')])"
      "('single', 3900297547, [(0, 0, 1.0, 0, true, [('DP-10', '3440x1440@59.973', {'underscanning': <false>})])], {}, [('DP-10', 'PHL', 'PHL 346P1C', 'UK02208021981'), ('DP-2', 'LEN', 'LEN T24i-10', 'VNA2MMCV'), ('eDP-1', 'AUO', '0x53ad', '0x00000000')])"
    ];
    "org/gnome/shell/extensions/display-configuration-switcher/display-configuration-switcher-shortcut-next" =
      [ "<Super>semicolon" ];
    "org/gnome/shell/extensions/display-configuration-switcher/display-configuration-switcher-shortcut-previous" =
      [ "<Shift><Super>colon" ];
  };
}
