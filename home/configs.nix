{ lib, ... }:
with lib;
{
  DOT_BASHRC = mkDefault ''
    nixconf() (
      [ -f flake.nix ] && [ -f flake.lock ] || exit 1
      nixfmt .
      while true; do
        git add -A
        git --no-pager diff --cached
        WORK_BRANCH=$(git branch --show-current)
        read -p "Do you wish to commit these changes on $WORK_BRANCH? [Yn] " yn
        case $yn in
          [Nn]* )
            break
            ;;
          * )
            git commit -m "$(date +%Y/%m/%d-%H:%M:%S)"
            git fetch
            git rebase origin/$WORK_BRANCH  || (git rebase --abort && echo "Rebase conflict...aborting!" && exit 1)
            git push
            break
            ;;
        esac
      done
    )

    if command -v fzf-share >/dev/null; then
      source "$(fzf-share)/key-bindings.bash"
      source "$(fzf-share)/completion.bash"
    fi

    source <(kubectl completion bash)
    complete -o default -o nospace -F __start_kubectl k

    if test -f ~/.bashrc.local; then
    . ~/.bashrc.local
    fi
  '';
}
