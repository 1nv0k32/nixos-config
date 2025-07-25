{ pkgs, ... }:
let
  bashOpts = ''
    set -euo pipefail
  '';
  nixconf = pkgs.writeShellScriptBin "nixconf" ''
    ${bashOpts}
    [ -f flake.nix ] && [ -f flake.lock ] || false
    cd $(git rev-parse --show-toplevel 2> /dev/null)
    while true; do
      read -p "Do you wish to update flake? [Ny] " yn
      case $yn in
        [Yy]* )
          nix flake update
          ;;
      esac
      git add -A
      pre-commit run --all-files || continue
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
  '';
  nixup = pkgs.writeShellScriptBin "nixup" ''
    ${bashOpts}
    sudo nix flake update --flake path:/etc/nixos
    sudo nixos-rebuild switch
  '';
in
{
  environment.systemPackages = with pkgs; [
    nixconf
    nixup
    git
    pre-commit
    nixfmt-rfc-style
  ];
}
