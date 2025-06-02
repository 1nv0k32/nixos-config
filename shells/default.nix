{ pkgs, ... }:
{
  default =
    let
      nixconf = pkgs.writeShellScriptBin "nixconf" ''
        #! ${pkgs.stdenv.shell}
        set -euo pipefail
        [ -f flake.nix ] && [ -f flake.lock ] || false
        cd $(${pkgs.git}/bin/git rev-parse --show-toplevel 2> /dev/null)
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
      '';
      nixup = pkgs.writeShellScriptBin "nixup" ''
        #! ${pkgs.stdenv.shell}
        set -euo pipefail
        sudo nix flake update --flake path:/etc/nixos
        sudo nixos-rebuild switch
      '';
    in
    pkgs.mkShell {
      buildInputs = [
        nixconf
        nixup
      ];
    };
}
