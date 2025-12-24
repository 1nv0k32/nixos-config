{ ... }:
{
  imports = [
    ./bash.nix
    ./zsh.nix
    ./direnv.nix
    ./git.nix
    ./ssh.nix
    ./yubikey.nix
    ./nvim.nix
    ./tmux.nix
    ./fzf.nix
  ];
}
