# Proposal: Refactor NixOS configuration to a dendritic flake-parts layout

## Why

The current `flake.nix` builds systems through opaque module tiers (`defaultModules`, `baseModules`, `extraModules`, `guiModules`) and per-host `systemTypes`. The names do not describe what a host *does*, adding a host means editing the central flake, and cross-cutting concerns (NixOS, nix-darwin, home-manager) are scattered across separate directories. A dendritic, role-based structure will make the configuration self-documenting, let hosts be composed from named capabilities, and let us share home-manager/darwin concerns through the same module tree.

## What Changes

- **BREAKING**: Replace the hand-rolled `flake.nix` outputs with a `flake-parts` + `import-tree` setup. Every `.nix` file under `modules/` becomes a flake-parts module and is auto-discovered.
- **BREAKING**: Delete the old top-level directories `src/`, `home/`, `pkgs/`, `system/`, `modules/gui/`, `modules/etc/`, `modules/shells/`, `modules/tools/`, `overrides/`, and `shells/` after their contents are moved into the new `modules/` tree.
- Introduce a `modules/` tree organized by concern:
  - `modules/roles/` — flat, composable profiles: `core`, `base`, `server`, `desktop`, `mobile`, `development`, `security`, `media-tools`, `media-server`.
  - `modules/hardware/` — per-machine-type profiles: `z13g2`, `mac`, `hetzner`, `rpi5`, `avf`, `wsl`, `qemu`, `utm`, `parallels`.
  - `modules/hosts/` — host declarations (`nyx`, `nyxpi`, `nyxmac`, `nyxdroid`, `nyxwsl`, `nyxvm`, `nyxutm`, `nyxprl`, `nyxdarwin`) that import roles + hardware + set `hostName`/`domain`.
  - `modules/programs/`, `modules/services/`, `modules/system/`, `modules/packages/`, `modules/devshells/`, `modules/home/`, `modules/flake/` — leaf modules that roles and hosts compose.
- Main flake exports buildable `nixosConfigurations` and `darwinConfigurations` using a minimal dummy root filesystem so CI can evaluate them without real `hardware-configuration.nix`.
- Thin the deploy flake (`flakes/flake.nix`) so it only supplies per-machine `hardware-configuration.nix`, `local.nix`, and sops secrets; host identity and role composition live in the main flake.
- Add standalone `homeConfigurations.rick` built from the same home-manager base module used by NixOS and nix-darwin.
- Remove unused `specialArgs` (`openstack-nix`, `nixos-raspberrypi`) and replace ad-hoc value passing with flake-parts options (`stateVersion`, source path).

## Capabilities

### New Capabilities

- `dendritic-flake-structure`: flake.nix uses flake-parts; modules under `modules/` are auto-discovered via import-tree; flake outputs (packages, devShells, formatter, configurations) are declared from modules.
- `role-based-profiles`: NixOS and nix-darwin hosts are composed from flat, named roles (`core`, `base`, `server`, `desktop`, `mobile`, `development`, `security`, `media-tools`, `media-server`) instead of the current `default/base/extra/gui` tiers.
- `hardware-profiles`: machine-type-specific configuration (hardware modules, disko, system tweaks) is isolated in `modules/hardware/<machine>.nix` and selected per host.
- `home-manager-flake`: home-manager configuration is part of the dendritic module tree; a shared base is used by NixOS-integrated homes and nix-darwin; a standalone `homeConfigurations.rick` is exposed.
- `deploy-flake-thin`: the deploy flake only adds per-machine `hardware-configuration.nix`, `local.nix`, and secrets; the main flake owns host identity and role composition.

### Modified Capabilities

None. There are no existing specs in `openspec/specs/`.

## Impact

- `flake.nix` becomes a minimal manifest of inputs.
- All NixOS, nix-darwin, and home-manager modules move under `modules/`.
- The `flakes/flake.nix` deploy flake shrinks dramatically; existing hosts continue to build after migrating local modules.
- CI in `.github/workflows/checks_flake.yml` needs to run `nix flake check` from the repo root on the main flake (and optionally still on the deploy flake).
- Existing `nixos-rebuild` commands using `github:1nv0k32/nixos-config?dir=flakes#HOST` remain valid because the deploy flake output names do not change.
