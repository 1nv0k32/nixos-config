{ lib, ... }:
{
  DOT_BASHRC = lib.mkDefault ''
    alias k='kubectl'
    source <(kubectl completion bash)
    complete -o default -o nospace -F __start_kubectl k

    if test -f ~/.bashrc.local; then
    . ~/.bashrc.local
    fi
  '';
}
