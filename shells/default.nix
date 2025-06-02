{ pkgs, ... }:
{
  default = pkgs.mkShell {
    shellHook = ''
      nixconf() (
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
      )

      nixup() (
        sudo nix flake update --flake path:/etc/nixos
        sudo nixos-rebuild switch
      )

      # Export for direnv
      export_function() {
        local name=$1
        local alias_dir=$PWD/.direnv/aliases
        mkdir -p "$alias_dir"
        PATH_add "$alias_dir"
        local target="$alias_dir/$name"
        if declare -f "$name" >/dev/null; then
            echo "#!/usr/bin/env bash" > "$target"
            declare -f "$name" >> "$target" 2>/dev/null
            echo "$name" >> "$target"
            chmod +x "$target"
        fi
      }

      export_function nixconf
      export_function nixup
    '';
  };
}
