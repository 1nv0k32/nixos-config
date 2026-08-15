# Capability: Thin deploy flake

## ADDED Requirements

### Requirement: Host identity lives in the main flake

Host modules under `modules/hosts/` in the main flake SHALL define `networking.hostName`, `networking.domain` (where applicable), role composition, and hardware profile selection. The deploy flake SHALL NOT redefine host identity.

#### Scenario: Host name in main flake

- **WHEN** inspecting `modules/hosts/nyx.nix`
- **THEN** `networking.hostName = "nyx"` is set inside that module

#### Scenario: Deploy flake does not set hostName

- **WHEN** inspecting `flakes/flake.nix`
- **THEN** no `networking.hostName` assignments exist

### Requirement: Deploy flake only adds local machine data

The deploy flake SHALL only import host modules from the main flake and append per-machine files: `./hardware-configuration.nix`, `./local.nix`, and SOPS secrets files where applicable.

#### Scenario: Minimal deploy flake host

- **WHEN** `flakes/flake.nix` defines `nixosConfigurations.nyx`
- **THEN** its module list contains `cfg.modules.nixos.hosts.nyx`, `./hardware-configuration.nix`, and `./local.nix`

### Requirement: Existing deployment URLs remain valid

After the refactor, `nixos-rebuild switch --flake github:1nv0k32/nixos-config?dir=flakes#<host>` SHALL continue to work for every host that currently supports it.

#### Scenario: nyx deploy URL

- **WHEN** a user runs `nixos-rebuild switch --flake github:1nv0k32/nixos-config?dir=flakes#nyx`
- **THEN** the build succeeds using the refactored deploy flake

#### Scenario: Darwin deploy URL

- **WHEN** a user runs `darwin-rebuild switch --flake github:1nv0k32/nixos-config?dir=flakes#nyxdarwin`
- **THEN** the build succeeds using the refactored deploy flake

### Requirement: Main flake contains buildable CI configurations

The main flake SHALL expose `nixosConfigurations` and `darwinConfigurations` for each host using a dummy hardware profile, so CI can run `nix flake check` without per-machine secrets or `hardware-configuration.nix`.

#### Scenario: CI build of nyx

- **WHEN** CI runs `nix flake check` on the main flake
- **THEN** `nixosConfigurations.nyx` evaluates and builds the system toplevel
