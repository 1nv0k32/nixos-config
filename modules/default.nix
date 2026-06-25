{ ... }:
{
  imports = [
    ./shells
    ./direnv.nix
    ./git.nix
    ./ssh.nix
    ./yubikey.nix
    ./tmux.nix
    ./fzf.nix
    ./kube.nix
  ];
}
