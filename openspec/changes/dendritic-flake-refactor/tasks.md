# Tasks: Dendritic flake-parts refactor

## 1. Preparation

- [ ] 1.1 Add `flake-parts` and `import-tree` to `flake.nix` inputs and run `nix flake lock`.
- [ ] 1.2 Create the new directory skeleton: `modules/{_lib,flake,packages,programs,system,services,roles,hardware,hosts,home}` and `secrets/hosts/`.
- [ ] 1.3 Create `modules/_lib/` helpers for shared functions reused across modules.

## 2. Migrate leaf modules into the dendritic tree

- [ ] 2.1 Move package overlays, scripts, and custom packages from `pkgs/` and `overrides/` to `modules/packages/` as flake-parts modules.
- [ ] 2.2 Move shell/tool program modules from `modules/shells/`, `modules/tools/` into `modules/programs/`.
- [ ] 2.3 Move system config from `src/lib/` and `src/base.nix` into `modules/system/` (boot, networking, console, logind, systemd, nix, options).
- [ ] 2.4 Move user definitions from `src/users.nix` into `modules/system/users.nix` or `modules/roles/base.nix` as appropriate.
- [ ] 2.5 Move optional services from `modules/etc/` into `modules/services/`.
- [ ] 2.6 Move home-manager modules from `home/` into `modules/home/`.
- [ ] 2.7 Move devShells from `shells/` into `modules/devshells/` and the formatter/package wiring into `modules/flake/`.

## 3. Implement flake-level options and helpers

- [ ] 3.1 Implement `modules/flake/state-version.nix` to expose `flake.lib.stateVersion`.
- [ ] 3.2 Implement `modules/flake/source-path.nix` to expose `flake.sourcePath` (used for `/etc/nixos/flake.nix` symlink).
- [ ] 3.3 Implement `modules/flake/formatter.nix` to expose the formatter via `perSystem`.
- [ ] 3.4 Implement `modules/flake/packages.nix` to expose `packages.nvim` and any other perSystem packages.
- [ ] 3.5 Implement `modules/flake/devshells.nix` to expose `devShells.default`, `kernel`, `python`, `go`, `fhs`.

## 4. Define role modules

- [ ] 4.1 Implement `modules/roles/core.nix` importing overlays, nix settings, options, shells, and core packages/tools.
- [ ] 4.2 Implement `modules/roles/base.nix` importing users, boot basics, system/network/console/time modules.
- [ ] 4.3 Implement `modules/roles/server.nix` importing SSH and authorized-keys configuration.
- [ ] 4.4 Implement `modules/roles/desktop.nix` importing GNOME, GUI apps, flatpak, dconf, printing, fwupd, Plymouth.
- [ ] 4.5 Implement `modules/roles/mobile.nix` with networkmanager, fprintd, and laptop power tweaks.
- [ ] 4.6 Implement `modules/roles/development.nix` importing podman, libvirt, quickemu, distrobox, and devops packages.
- [ ] 4.7 Implement `modules/roles/security.nix` importing yubikey/U2F, LUKS, and security/reverse-engineering tools.
- [ ] 4.8 Implement `modules/roles/media-tools.nix` importing desktop media packages.
- [ ] 4.9 Implement `modules/roles/media-server.nix` importing minidlna and transmission.

## 5. Define hardware profiles

- [ ] 5.1 Implement `modules/hardware/dummy.nix` with a minimal root filesystem using `lib.mkDefault` for CI builds.
- [ ] 5.2 Implement `modules/hardware/z13g2.nix` importing nixos-hardware ThinkPad Z13 Gen2 support and disko config.
- [ ] 5.3 Implement `modules/hardware/mac.nix` importing nixos-apple-silicon support.
- [ ] 5.4 Implement `modules/hardware/hetzner.nix` importing srvos Hetzner support and disko config.
- [ ] 5.5 Implement `modules/hardware/rpi5.nix` importing nixos-hardware Raspberry Pi 5 support and disko config.
- [ ] 5.6 Implement `modules/hardware/avf.nix`, `wsl.nix`, `qemu.nix`, `utm.nix`, and `parallels.nix` for VM/WSL targets.
- [ ] 5.7 Verify every hardware profile includes `disko` only where the original system type used it.

## 6. Define host modules

- [ ] 6.1 Implement `modules/hosts/nyx.nix` with role composition, `hardware-z13g2`, `hostName = "nyx"`, `domain = "nyxlan.internal"`, and dummy hardware config.
- [ ] 6.2 Implement `modules/hosts/nyxpi.nix` with `hardware-rpi5`, `hostName = "nyxpi"`, and appropriate roles.
- [ ] 6.3 Implement `modules/hosts/nyxmac.nix` with `hardware-mac`, `hostName = "nyxmac"`, and appropriate roles.
- [ ] 6.4 Implement `modules/hosts/nyxdroid.nix` with `hardware-avf`, `hostName = "nyxdroid"`, and appropriate roles.
- [ ] 6.5 Implement `modules/hosts/nyxwsl.nix` with `hardware-wsl`, `hostName = "nyxwsl"`, and appropriate roles.
- [ ] 6.6 Implement `modules/hosts/nyxvm.nix` with `hardware-qemu`, `hostName = "nyxvm"`, and appropriate roles.
- [ ] 6.7 Implement `modules/hosts/nyxutm.nix` with `hardware-utm`, `hostName = "nyxutm"`, and appropriate roles.
- [ ] 6.8 Implement `modules/hosts/nyxprl.nix` with `hardware-parallels`, `hostName = "nyxprl"`, and appropriate roles.
- [ ] 6.9 Implement `modules/hosts/nyxdarwin.nix` as a nix-darwin configuration with `hostName = "nyxdarwin"` and shared home-manager base.

## 7. Rewrite flake.nix

- [ ] 7.1 Replace `flake.nix` outputs with `flake-parts.lib.mkFlake { inherit inputs; }`.
- [ ] 7.2 Import `flake-parts.flakeModules.modules` and `(import-tree ./modules)`.
- [ ] 7.3 Ensure every NixOS host configuration loads `home-manager`, `sops-nix`, and `nixvim` modules globally.
- [ ] 7.4 Ensure darwin configuration loads `home-manager` and `nixvim` darwin modules globally.
- [ ] 7.5 Verify `nix flake metadata` and `nix flake show` succeed.

## 8. Thin the deploy flake

- [ ] 8.1 Rewrite `flakes/flake.nix` to import host modules from the main flake and add `./hardware-configuration.nix` and `./local.nix`.
- [ ] 8.2 Ensure deploy flake still exposes the same `nixosConfigurations` and `darwinConfigurations` output names.
- [ ] 8.3 Verify the deploy flake evaluates: `nix flake metadata ./flakes`.

## 9. Home-manager integration

- [ ] 9.1 Implement `modules/home/base.nix` as a flake-parts home-manager module.
- [ ] 9.2 Wire `home-manager.sharedModules` in `roles/base.nix` (NixOS) and the darwin host module to use the shared base.
- [ ] 9.3 Implement standalone `flake.homeConfigurations.rick` in a module under `modules/flake/` or `modules/home/`.
- [ ] 9.4 Ensure the standalone home configuration evaluates without NixOS-only options.

## 10. Secrets migration

- [ ] 10.1 Create `secrets/hosts/` directory and migrate any host-specific sops files.
- [ ] 10.2 Update `sops.defaultSopsFile` paths in host modules to point to `../../secrets/hosts/<name>.yaml`.
- [ ] 10.3 Ensure sops-nix keys and `.sops.yaml` remain functional.

## 11. Delete old directories

- [ ] 11.1 Delete `src/`, `home/`, `pkgs/`, `system/`, `overrides/`, and `shells/` after their contents are migrated.
- [ ] 11.2 Delete old `modules/gui/`, `modules/etc/`, `modules/shells/`, and `modules/tools/` after migration.
- [ ] 11.3 Verify no stale `.nix` files remain outside `modules/`, `flakes/`, `openspec/`, `.devin/`, `.github/`, and `secrets/`.

## 12. CI and validation

- [ ] 12.1 Update `.github/workflows/checks_flake.yml` to run `nix flake check` from the repo root on the main flake.
- [ ] 12.2 Optionally keep a deploy-flake check that copies `checks_local.nix` to `local.nix` inside `flakes/`.
- [ ] 12.3 Run `nix flake check` on the main flake and fix all eval errors.
- [ ] 12.4 Build each host toplevel: `nix build .#nixosConfigurations.<host>.config.system.build.toplevel` for every NixOS host.
- [ ] 12.5 Build darwin configuration: `nix build .#darwinConfigurations.nyxdarwin.config.system.build.toplevel`.
- [ ] 12.6 Build standalone home configuration: `nix build .#homeConfigurations.rick.activationPackage`.
- [ ] 12.7 Build the deploy flake and verify it still produces the expected `nixosConfigurations` and `darwinConfigurations`.
