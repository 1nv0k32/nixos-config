{ ... }:
{
  imports = [
    ./shells
    ./nixvim
    ./direnv.nix
    ./git.nix
    ./ssh.nix
    ./yubikey.nix
    ./tmux.nix
    ./fzf.nix
    ./kube.nix
  ];
}
