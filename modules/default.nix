{ ... }:
{
  imports = [
    ./shells
    ./direnv.nix
    ./git.nix
    ./ssh.nix
    ./yubikey.nix
    ./nvim.nix
    ./tmux.nix
    ./fzf.nix
  ];

  environment.sysConf.gui.enable = true;
  programs.dconf.enable = true;
}
