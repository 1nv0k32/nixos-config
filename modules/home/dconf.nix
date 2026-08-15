{
  pkgs,
  lib,
  ...
}:
{
  flake.modules.homeManager.dconf = { pkgs, lib, ... }: {
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
        idle-delay = lib.hm.gvariant.mkUint32 600;
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
        check-alive-timeout = lib.hm.gvariant.mkInt32 0;
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
      "org/gnome/shell/window-switcher" = {
        current-workspace-only = true;
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
        command = "${lib.getExe pkgs.kitty} --start-as=maximized";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "suspend";
        binding = "<Super><Shift>S";
        command = "systemctl suspend";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
        name = "flameshot";
        binding = "Print";
        command = "script --command ' flameshot gui --raw | wl-copy ' /dev/null";
      };

      "org/gnome/shell" = {
        disable-user-extensions = false;
      };
    };
  };
}
