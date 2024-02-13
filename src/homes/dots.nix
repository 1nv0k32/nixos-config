{ pkgs, lib }:
with lib;
{
  DOT_BASHRC = mkDefault ''
    nixconf() (
      [ -z $1 ] && exit 1
      cd -- $1 || exit 1
      nixpkgs-fmt .
      while true; do
        git --no-pager diff
        read -p "Do you wish to commit these changes? [Yn] " yn
        case $yn in
            [Nn]* )
              break
              ;;
            * )
              git add .
              git commit -m "$(date +%Y/%m/%d-%H:%M:%S)"
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
