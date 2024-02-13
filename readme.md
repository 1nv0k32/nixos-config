# NixOS

```sh
curl -s https://raw.githubusercontent.com/1nv0k32/nixos/main/configuration.nix -o /etc/nixos/configuration.nix
nixos-generate-config
nix-channel --remove nixos
nix-channel --add https://nixos.org/channels/nixos-23.11 nixos
nix-channel --update
nixos-rebuild boot --upgrade-all
```

