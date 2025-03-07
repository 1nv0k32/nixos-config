# NixOS

## Installation

```sh
curl -s "https://raw.githubusercontent.com/1nv0k32/nixos-config/main/flakes/flake.nix?v=$(date +%s)" -o /etc/nixos/flake.nix
nixos-generate-config
nixos-rebuild boot --upgrade-all
```
