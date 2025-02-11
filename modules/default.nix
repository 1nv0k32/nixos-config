{ lib, ... }:
{
  imports = [
    ./sysconf.nix
    ./bash.nix
    ./git.nix
    ./ssh.nix
    ./gpg.nix
    ./nvim.nix
    ./tmux.nix
    ./fzf.nix
    ./postfix.nix
  ] ++ lib.optional (builtins.pathExists ./dev.nix) (import ./dev.nix);
}
