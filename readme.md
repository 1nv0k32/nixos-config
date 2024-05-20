# NixOS

```sh
export BRANCH=dev
curl -s https://raw.githubusercontent.com/1nv0k32/nixoscfg/${BRANCH}/misc/flake.nix -o /etc/nixos/flake.nix
nixos-generate-config
nixos-rebuild boot --upgrade-all
```
