{ pkgs, lib }:
with lib;
{
  DOT_BASHRC = mkDefault ''
    nixconf() (
      [ -z $1 ] && exit 1
      cd -- $1 || exit 1
      nixpkgs-fmt .
      while true; do
        git add -A
        git --no-pager diff --cached
        read -p "Do you wish to commit these changes? [Yn] " yn
        case $yn in
          [Nn]* )
            break
            ;;
          * )
            
            git commit -m "$(date +%Y/%m/%d-%H:%M:%S)"
            git rebase origin/main  || (git rebase --abort && echo "Rebase conflict...aborting!" && exit 1)
            git push
            break
            ;;
        esac
      done
    )

    if test -f ~/.bashrc.local; then
    . ~/.bashrc.local
    fi
  '';
}

# vim:expandtab ts=2 sw=2
