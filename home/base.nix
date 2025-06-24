{
  stateVersion,
  config,
  pkgs,
  ...
}@attrs:
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
      bashrcExtra = ''
        alias k='kubectl'
        source <(kubectl completion bash)
        complete -o default -o nospace -F __start_kubectl k

        if test -f ~/.bashrc.local; then
        . ~/.bashrc.local
        fi
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
