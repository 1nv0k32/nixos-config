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
    ./kube.nix
  ];
}
