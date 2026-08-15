# Design: Dendritic flake-parts refactor

## Context

The repository currently uses a hand-rolled flake structure in `flake.nix` that exports `nixosModules.systemTypes.*`. Each system type is a function that builds a NixOS or nix-darwin system by stacking module tiers:

- `defaultModules` → overlays + `modules/` + `src/default.nix`
- `baseModules` → `defaultModules` + `src/base.nix` + `pkgs/base.nix`
- `extraModules` → `baseModules` + initrd/LUKS + `src/extra.nix` + `pkgs/extra.nix`
- `guiModules` → `extraModules` + `modules/gui/`

The deploy flake at `flakes/flake.nix` imports the library flake and assigns a `systemType` to each host (`nyx`, `nyxpi`, `nyxmac`, etc.), adding per-machine `hardware-configuration.nix` and `local.nix`.

This works, but the tier names (`default`, `base`, `extra`, `gui`) describe *how much* is enabled, not *what* the host does. Adding a new host or changing its role requires editing the central `flake.nix`. Cross-cutting concerns (NixOS, nix-darwin, home-manager) live in different top-level directories.

## Goals / Non-Goals

**Goals:**
- Express each host as a composition of named, aspect-oriented roles (`core`, `base`, `server`, `desktop`, `mobile`, `development`, `security`, `media-tools`, `media-server`).
- Replace the hand-rolled flake with `flake-parts` + `import-tree` so modules under `modules/` are auto-discovered.
- Move host declarations (identity + role composition + hardware profile) into the main flake.
- Keep the deploy flake thin: it only supplies per-machine `hardware-configuration.nix`, `local.nix`, and secrets.
- Make the main flake buildable in CI using a minimal dummy root filesystem.
- Expose a shared home-manager base for NixOS-integrated and nix-darwin homes, plus a standalone `homeConfigurations.rick`.

**Non-Goals:**
- No changes to installed packages, services, or settings beyond what the reorganization requires.
- No new hosts or new user accounts.
- No changes to SOPS secrets or the deployment URL schema.
- No migration to `nix-darwin` modules that do not already exist.

## Decisions

### 1. flake-parts + import-tree for the main flake

**Decision:** Rewrite `flake.nix` to use `flake-parts.lib.mkFlake` and pass `(import-tree ./modules)` as the top-level module list.

**Rationale:** This removes hand-maintained `imports` lists and lets the directory structure document the configuration. `flake-parts` gives us typed flake outputs (`perSystem`, `flake.modules.*`, `flake.nixosConfigurations`) and a natural place for packages/devShells.

**Alternative considered:** Keep the current flake and manually import a new `modules/` tree. Rejected because it does not solve the import-list maintenance problem and does not unify packages/devShells/configurations under one module system.

### 2. Host declarations live in the main flake; deploy flake only adds local machine data

**Decision:** Each host gets a module under `modules/hosts/<name>.nix` that declares `flake.nixosConfigurations.<name>` (or `flake.darwinConfigurations.<name>`). The module imports roles, a hardware profile, and sets `networking.hostName`/`networking.domain`. The deploy flake imports the host module and adds the real `hardware-configuration.nix`, `local.nix`, and secrets.

**Rationale:** Host identity and intended role belong in the shared repository. Per-machine disk UUIDs and local overrides belong in the deploy flake.

**How the dummy build works:** The main flake's host module imports its hardware profile (e.g. `hardware.z13g2`). The main flake also adds a dummy generated `hardware-configuration.nix` that defines a minimal root filesystem with `lib.mkDefault`, so `nix flake check` can evaluate the host without real disk secrets. The deploy flake loads the same host module but replaces the dummy with the real `hardware-configuration.nix`.

### 3. Roles are flat and explicitly composed

**Decision:** Roles do not import each other. A host module explicitly imports `roles.core`, `roles.base`, `roles.desktop`, etc.

**Rationale:** Hierarchical roles hide dependencies and make it hard to see what a host actually enables. Flat composition is verbose but explicit and matches the goal of making module tiers understandable.

### 4. Hardware profiles are separate from roles

**Decision:** Machine-type-specific configuration (nixos-hardware imports, disko, system tweaks) lives in `modules/hardware/<machine>.nix`. Host modules import exactly one hardware profile.

**Rationale:** A host's *purpose* (desktop/server) and its *machine type* (ThinkPad / Mac / RPi5) are independent axes. Separating them avoids duplicating hardware logic across hosts.

### 5. Third-party module loading: global vs opt-in

**Decision:** `home-manager`, `sops-nix`, and `nixvim` modules are loaded globally for every NixOS/nix-darwin configuration. `disko` and `nixos-generators` are imported only by the hardware profiles or host modules that need them.

**Rationale:** Home-manager, sops, and nixvim are infrastructure that every host currently uses. Disko and generators are feature-specific and should be opt-in.

### 6. Secrets stay in a top-level `secrets/` directory

**Decision:** Encrypted host secrets move to `secrets/hosts/<name>.yaml`. Host modules reference them via relative path.

**Rationale:** Centralizes secrets outside the auto-discovered module tree, making it obvious what is sensitive and what is not.

### 7. Replace ad-hoc `specialArgs` with flake-parts options

**Decision:**
- `stateVersion` becomes a flake-parts option (e.g. `flake.stateVersion` or a custom option under `config.flake.stateVersion`).
- The path used to symlink `/etc/nixos/flake.nix` becomes a flake-parts option (e.g. `config.flake.sourcePath`).
- Drop `openstack-nix` and `nixos-raspberrypi` from `specialArgs`; they are currently unused in the repo.

**Rationale:** dendritic/flake-parts style discourages `specialArgs` for values that can be expressed as options. This makes modules self-describing and avoids magic arguments.

### 8. Big-bang migration

**Decision:** Create the new `modules/` tree, rewrite `flake.nix`, thin `flakes/flake.nix`, then delete the old directories (`src/`, `home/`, `pkgs/`, `system/`, `overrides/`, `shells/`, `modules/gui/`, `modules/etc/`, `modules/shells/`, `modules/tools/`) in a single change.

**Rationale:** The old structure and the new structure cannot coexist cleanly because both would try to own the same outputs (`nixosConfigurations`, `packages`, `devShells`). A single cutover is less confusing than a half-migrated state.

## Module tree layout

```
modules/
├── _lib/                       # helpers, NOT auto-imported
├── flake/
│   ├── formatter.nix           # perSystem formatter
│   ├── packages.nix            # perSystem packages (nvim, etc.)
│   ├── devshells.nix           # perSystem devShells
│   ├── state-version.nix       # flake-level stateVersion option
│   └── source-path.nix         # flake-level sourcePath option
├── packages/                   # custom packages, overlays, scripts
│   ├── overlays.nix
│   ├── scripts.nix
│   └── nvim.nix
├── programs/
│   ├── bash.nix
│   ├── zsh.nix
│   ├── git.nix
│   ├── ssh.nix
│   ├── nixvim.nix
│   └── ...
├── system/
│   ├── options.nix             # environment.sysConf options
│   ├── nix.nix
│   ├── boot.nix
│   ├── networking.nix
│   ├── console.nix
│   ├── logind.nix
│   └── systemd.nix
├── services/
│   ├── k3s.nix
│   ├── postfix.nix
│   ├── media-server.nix
│   └── wg_server.nix
├── roles/
│   ├── core.nix
│   ├── base.nix
│   ├── server.nix
│   ├── desktop.nix
│   ├── mobile.nix
│   ├── development.nix
│   ├── security.nix
│   ├── media-tools.nix
│   └── media-server.nix
├── hardware/
│   ├── dummy.nix               # CI dummy hardware-configuration
│   ├── z13g2.nix
│   ├── mac.nix
│   ├── hetzner.nix
│   ├── rpi5.nix
│   ├── avf.nix
│   ├── wsl.nix
│   ├── qemu.nix
│   ├── utm.nix
│   └── parallels.nix
├── hosts/
│   ├── nyx.nix
│   ├── nyxpi.nix
│   ├── nyxmac.nix
│   ├── nyxdroid.nix
│   ├── nyxwsl.nix
│   ├── nyxvm.nix
│   ├── nyxutm.nix
│   ├── nyxprl.nix
│   └── nyxdarwin.nix
└── home/
    ├── base.nix
    ├── dconf.nix
    └── terminal.nix
```

## Role contents

| Role | Current source | What it enables |
|---|---|---|
| `core` | `pkgs/overlays.nix`, `src/default.nix`, `src/lib/nix.nix`, `modules/shells/`, `modules/tools/{git,ssh,tmux,fzf,direnv,nixvim}`, `pkgs/base.nix` | Overlays, nix daemon settings, `environment.sysConf` options, shell defaults, core packages |
| `base` | `src/base.nix`, `src/users.nix`, `src/lib/{systemd,logind,networking,console}.nix` | Users, basic boot/network/console/time/hardware settings |
| `server` | `system/server.nix` | OpenSSH, authorized keys, server hardening |
| `desktop` | `modules/gui/`, Plymouth/quiet boot from `src/extra.nix`, printing, fwupd | GNOME, GUI apps, flatpak, dconf, desktop services |
| `mobile` | per-machine laptop tweaks (`system/z13g2`, `system/mac`, `system/utm`) | networkmanager, fprintd, laptop power settings |
| `development` | `modules/tools/kube.nix`, podman/libvirt from `src/extra.nix`, devops packages from `pkgs/extra.nix` | Dev tools, podman/libvirt/quickemu/distrobox |
| `security` | `modules/tools/yubikey.nix`, `overrides/initrd-luks.nix`, security tools from `pkgs/extra.nix` | Yubikey/U2F, LUKS, security/reverse-engineering tools |
| `media-tools` | media packages from `pkgs/extra.nix`, flameshot from `home/base.nix` | Desktop media tools |
| `media-server` | `modules/etc/media.nix` | minidlna, transmission |

## Flake-parts wiring sketch

```nix
# flake.nix
{
  inputs = {
    nixpkgs = ...;
    flake-parts = ...;
    import-tree = ...;
    home-manager = ...;
    sops-nix = ...;
    nixvim = ...;
    # ... existing inputs
  };

  outputs = inputs@{ self, flake-parts, import-tree, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        flake-parts.flakeModules.modules
        (import-tree ./modules)
      ];

      # Global flake-parts options/conventions can live here or in modules/flake/
      flake.stateVersion = "26.05";
    };
}
```

A host module:

```nix
# modules/hosts/nyx.nix
{ self, inputs, ... }:
{
  flake.nixosConfigurations.nyx = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit self; };
    modules = [
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.nixvim.nixosModules.nixvim
      self.modules.nixos.roles.core
      self.modules.nixos.roles.base
      self.modules.nixos.roles.desktop
      self.modules.nixos.roles.mobile
      self.modules.nixos.roles.development
      self.modules.nixos.roles.security
      self.modules.nixos.hardware.z13g2
      self.modules.nixos.hardware.dummy
      {
        networking.hostName = "nyx";
        networking.domain = "nyxlan.internal";
        sops.defaultSopsFile = ../../secrets/hosts/nyx.yaml;
      }
    ];
  };
}
```

A deploy flake host:

```nix
# flakes/flake.nix (thinned)
{
  inputs.cfg.url = "github:1nv0k32/nixos-config";
  outputs = { cfg, nixpkgs, ... }: {
    nixosConfigurations.nyx = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        cfg.modules.nixos.hosts.nyx
        ./hardware-configuration.nix
        ./local.nix
      ];
    };
  };
}
```

## Home-manager wiring

- `modules/home/base.nix` declares a `flake.modules.homeManager.base` module (class `homeManager` or `generic` depending on flake-parts module class availability).
- `roles/base.nix` (NixOS) sets `home-manager.sharedModules = [ self.modules.homeManager.base ]` and declares users.
- `modules/hosts/nyxdarwin.nix` (nix-darwin) sets `home-manager.sharedModules = [ self.modules.homeManager.base ]`.
- A separate module exposes `flake.homeConfigurations.rick = inputs.home-manager.lib.homeManagerConfiguration { ... modules = [ self.modules.homeManager.base ]; }`.

For standalone home-manager the conditional desktop-only background/face settings are omitted; they remain in the NixOS-integrated path via `mkIf` or by a separate `home/desktop.nix` module imported by the `desktop` role.

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| flake-parts eval errors obscure the offending module | Build incrementally: first get `nix flake metadata` and `nix flake show` working, then build `nixosConfigurations` one host at a time. |
| import-tree accidentally imports helper files | Strictly place anything that should not be a flake-parts module under `modules/_lib/`. Verify with `nix flake check`. |
| Dummy hardware config conflicts with real `hardware-configuration.nix` | Use `lib.mkDefault` in the dummy and ensure the deploy flake lists the real config after the host module. Test with the deploy flake before deleting old code. |
| Darwin/NixOS home-manager module class mismatch | Start with `generic` class for home-manager modules; if flake-parts rejects it, switch to a custom `homeManager` class or use a small flake-parts module that wires home-manager explicitly. |
| Big-bang breaks CI | Keep the old `flakes/flake.nix` check path green by updating `.github/workflows/checks_flake.yml` to also (or instead) run `nix flake check` from the repo root. |
| Secrets paths change | Update `sops.defaultSopsFile` references and verify key locations; keep the same SOPS key setup. |

## Migration Plan

1. Add `flake-parts` and `import-tree` to `flake.nix` inputs; run `nix flake lock`.
2. Create the new `modules/` directory tree.
3. Migrate leaf modules: `system/`, `src/lib/`, `modules/tools/`, `modules/shells/`, `modules/gui/`, `modules/etc/`, `home/`, `pkgs/`, `overrides/`, `shells/` into `modules/{system,programs,services,packages,devshells,home}`.
4. Implement `modules/flake/state-version.nix` and `modules/flake/source-path.nix` as flake-parts options.
5. Implement `modules/roles/*.nix` composing leaf modules.
6. Implement `modules/hardware/*.nix` for each machine type, including `dummy.nix`.
7. Implement `modules/hosts/*.nix` for each current host, importing roles + hardware + dummy config.
8. Rewrite `flake.nix` to use `flake-parts.lib.mkFlake` and `import-tree`.
9. Thin `flakes/flake.nix` to import host modules from the main flake and add local modules.
10. Delete old top-level directories.
11. Update `.github/workflows/checks_flake.yml` to run `nix flake check` at the repo root.
12. Test: `nix flake check`, then build every host (`nix build .#nixosConfigurations.nyx.config.system.build.toplevel`), then build the deploy flake.

## Open Questions

1. What exact flake-parts option names should we use for `stateVersion` and the deploy-flake source path? Suggest `flake.stateVersion` and `flake.sourcePath`, but need to confirm they do not clash with flake-parts builtins.
2. Should `modules/hosts/<name>.nix` import its hardware profile, or should hardware be selected by the consumer (main-flake CI vs deploy flake)? Decision above assumes the host module imports it.
3. What flake-parts module class should we use for home-manager modules (`homeManager` vs `generic`)? Need to test with flake-parts' `flake.modules` type checking.
4. File naming convention: kebab-case vs snake_case for module files and role/hardware names. Suggest kebab-case for public module names and snake_case for Nix files to match existing style.
