{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
let
  customConfigs = (import ./configs.nix { inherit lib; });
  gnomeExtensions = with pkgs.gnomeExtensions; [
    appindicator
    just-perfection
    tiling-assistant
    caffeine
    unblank
  ];
in
{
  imports = [ (import ./libs/dconf.nix { inherit gnomeExtensions lib; }) ];

  home = {
    homeDirectory = "/home/${config.home.username}";
    file."${config.home.homeDirectory}/.background-image" = {
      source = ./bin/backgroud-image;
    };
    file."${config.home.homeDirectory}/.face" = {
      source = ./bin/backgroud-image;
    };
    packages = gnomeExtensions;
  };

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    shellAliases = {
      cat = "bat -p";
      k = "kubectl";
      nixup = "sudo bash -c 'nix flake update /etc/nixos && nixos-rebuild switch'";
    };
    bashrcExtra = customConfigs.DOT_BASHRC;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = {
        warn_timeout = 0;
      };
      whitelist.prefix = [ "~/" ];
    };
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
      cursorShape = "ibeam";
      cursorBlinkMode = "on";
      font = "NotoMono Nerd Font Mono 15";
      customCommand = "tmux";
    };
  };

  programs.chromium = {
    enable = true;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "ponfpcnoihfmfllpaingbgckeeldkhle"; } # enhancer for youtube
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
    ];
  };
}
