{
  stateVersion,
  lib,
  config,
  pkgs,
  ...
}:
let
  customConfigs = (import ./configs.nix { inherit lib; });
in
{
  imports = [ (import ./libs/dconf.nix { inherit lib pkgs; }) ];

  home = {
    stateVersion = stateVersion;
    homeDirectory = "/home/${config.home.username}";
    file."${config.home.homeDirectory}/.background-image" = {
      source = ./bin/backgroud-image.jpg;
    };
    file."${config.home.homeDirectory}/.face" = {
      source = ./bin/backgroud-image.jpg;
    };
  };

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    bashrcExtra = customConfigs.DOT_BASHRC;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.readline = {
    enable = true;
    extraConfig = ''
      set completion-ignore-case on
      set colored-completion-prefix on
      set skip-completed-text on
      set visible-stats on
      set colored-stats on
      set mark-symlinked-directories on
    '';
  };

  programs.ssh = {
    enable = true;
    includes = [ "~/.ssh/config.d/*.config" ];
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
      cursorShape = "block";
      cursorBlinkMode = "off";
      font = "NotoMono Nerd Font Mono 15";
      customCommand = "tmux";
    };
  };
}
