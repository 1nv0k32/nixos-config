{ pkgs, ... }:
{
  default = pkgs.mkShell {
    shellHook = ''
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

      nixup() (
        sudo ${pkgs.bash}/bin/bash -c 'nix flake update --flake path:/etc/nixos && nixos-rebuild switch'"
      )

      export_function nixconf
      export_function nixup
    '';
  };
}
