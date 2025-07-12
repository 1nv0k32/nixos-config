{ ... }:
{
  imports = [
    ./bash.nix
    ./direnv.nix
    ./git.nix
    ./ssh.nix
    ./gpg.nix
    ./yubikey.nix
    ./nvim.nix
    ./tmux.nix
    ./fzf.nix
    ./postfix.nix
  ];
}
