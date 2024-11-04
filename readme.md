# NixOS

## Installation

```sh
curl -s "https://raw.githubusercontent.com/1nv0k32/nixos-config/main/misc/flake.nix?token=$(date +%s)" -o /etc/nixos/flake.nix
nixos-generate-config
nixos-rebuild boot --upgrade-all
```

## RPi

Add this to `local.nix`

```nix
{
  nixConfig = {
    extra-trusted-public-keys = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    extra-substituters = "https://nix-community.cachix.org";
  };
}
```
