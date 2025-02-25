{ lib, pkgs, ... }:
{
  DOT_BASHRC = lib.mkDefault ''
    nixconf() (
      [ -f flake.nix ] && [ -f flake.lock ] || exit 1
      ${pkgs.pre-commit}/bin/pre-commit run --all-files
      ${pkgs.findutils}/bin/find -regex ".*\.nix" -exec ${pkgs.nixfmt-rfc-style}/bin/nixfmt {} \;
      while true; do
        ${pkgs.git}/bin/git add -A
        ${pkgs.git}/bin/git --no-pager diff --cached
        WORK_BRANCH=$(${pkgs.git}/bin/git branch --show-current)
        read -p "Do you wish to commit these changes on $WORK_BRANCH? [Yn] " yn
        case $yn in
          [Nn]* )
            break
            ;;
          * )
            ${pkgs.git}/bin/git commit -m "$(date +%Y/%m/%d-%H:%M:%S)"
            ${pkgs.git}/bin/git fetch
            ${pkgs.git}/bin/git rebase origin/$WORK_BRANCH  || (${pkgs.git}/bin/git rebase --abort && echo "Rebase conflict...aborting!" && exit 1)
            ${pkgs.git}/bin/git push
            break
            ;;
        esac
      done
    )

    alias k='kubectl'
    source <(kubectl completion bash)
    complete -o default -o nospace -F __start_kubectl k

    if test -f ~/.bashrc.local; then
    . ~/.bashrc.local
    fi
  '';
}
