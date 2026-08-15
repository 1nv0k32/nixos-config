{
  pkgs,
  lib,
  ...
}:
{
  flake.modules.homeManager.terminal = { pkgs, lib, ... }: {
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
        cursorShape = "block";
        cursorBlinkMode = "off";
        font = "NotoMono Nerd Font Mono 14";
        customCommand = "${lib.getExe pkgs.tmux}";
      };
    };

    programs.kitty = {
      enable = true;
      font = {
        name = "NotoMono Nerd Font Mono";
        size = 14;
      };
      settings = {
        cursor_shape = "block";
        cursor_blink_interval = 0;
        enable_audio_bell = "no";
        shell = "${lib.getExe pkgs.tmux}";
      };
    };
  };
}
