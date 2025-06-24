{
  stateVersion,
  config,
  pkgs,
  ...
}@attrs:
let
  customConfigs = pkgs.callPackage ./configs.nix attrs;
in
{
  imports = [
    (import ./libs/dconf.nix attrs)
    (import ./libs/terminal.nix attrs)
  ];

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

  programs = {
    bash = {
      enable = true;
      bashrcExtra = customConfigs.DOT_BASHRC;
    };

    readline = {
      enable = true;
      extraConfig = ''
        set completion-ignore-case on
        set colored-completion-prefix on
        set skip-completed-text on
        set visible-stats on
        set colored-stats on
        set mark-symlinked-directories on
        set show-all-if-ambiguous on
      '';
    };

    ssh = {
      enable = true;
      includes = [ "~/.ssh/config.d/*.config" ];
    };

    git = {
      enable = true;
    };
  };
}
