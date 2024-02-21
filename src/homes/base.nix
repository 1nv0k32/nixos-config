{ customPkgs, systemConfig }: { config, pkgs, lib, ... }:
let
  customDots = pkgs.callPackage (import ./dots.nix) { };
in
with lib.hm.gvariant;
{
  programs.home-manager.enable = true;

  home = {
    homeDirectory = "/home/${config.home.username}";
    file."${config.home.homeDirectory}/.background-image" = { source = ../bin/backgroud-image; };
    file."${config.home.homeDirectory}/.face" = { source = ../bin/backgroud-image; };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      cat = "bat -p";
    };
    bashrcExtra = customDots.DOT_BASHRC;
  };

  programs.ssh = {
    enable = true;
    includes = [ "~/.ssh/config.d/*.config" ];
    matchBlocks."*".proxyCommand =
      let
        proxy_url = builtins.elemAt (builtins.split "/" systemConfig.networking.proxy.default) 4;
      in
      lib.mkIf (systemConfig.networking.proxy.default != null) "${pkgs.netcat}/bin/nc -X connect -x ${proxy_url} %h %p";
  };

  programs.git = {
    enable = true;
  };

  programs.gnome-terminal = {
    enable = true;
    themeVariant = "dark";
    showMenubar = false;
    profile."352f48f0-7279-422e-9e0a-95228e86bd1d" = {
      visibleName = "default";
      default = true;
      allowBold = true;
      audibleBell = false;
      showScrollbar = false;
      cursorShape = "ibeam";
      cursorBlinkMode = "on";
      font = "Monospace 13";
      customCommand = "tmux";

    };
  };

  programs.chromium = {
    enable = true;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "ponfpcnoihfmfllpaingbgckeeldkhle"; } # enhancer for youtube
      { id = "dhegojkfhodaifdnkoigmdoncoonbifd"; } # watch later for youtube
    ];
  };

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
      idle-delay = mkUint32 300;
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
      sleep-inactive-battery-type = "nothing";
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
    };
    "org/gnome/desktop/input-sources" = {
      per-window = true;
      sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "ir" ]) ];
    };
    "org/gnome/desktop/wm/preferences" = {
      audible-bell = false;
      auto-raise = true;
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
      next = [ "<Control><Super>Right" ];
      play = [ "<Control><Super>Down" ];
      previous = [ "<Control><Super>Left" ];
      stop = [ "<Control><Super>Up" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "gnome-terminal";
      binding = "<Super>Return";
      command = "gnome-terminal --maximize";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "suspend";
      binding = "<Super><Shift>S";
      command = "systemctl suspend";
    };

    # Extensions
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = lib.lists.forEach customPkgs.GNOME_EXT (e: e.extensionUuid);
    };

    "org/gnome/shell/extensions/just-perfection" = {
      animation = mkInt32 4;
      panel = true;
      panel-in-overview = true;
      double-super-to-appgrid = false;
      window-demands-attention-focus = true;
      startup-status = mkInt32 0;
      osd-position = mkInt32 2;
    };

    "org/gnome/shell/extensions/unblank" = {
      power = true;
      time = mkInt32 0;
    };
  };
}

# vim:expandtab ts=2 sw=2

