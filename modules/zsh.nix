{ ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      theme = "gnzh";
      plugins = [
        "git"
        "vi-mode"
      ];
    };
  };
}
