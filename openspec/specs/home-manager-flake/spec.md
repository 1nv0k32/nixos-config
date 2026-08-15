# Capability: Home-manager flake integration

## Purpose

TBD

## Requirements

### Requirement: Home-manager modules live in the dendritic tree

Home-manager configuration SHALL be provided by modules under `modules/home/` and exposed via `flake.modules.homeManager.*` (or an equivalent class). These modules SHALL participate in the same `import-tree` discovery as the rest of the configuration.

#### Scenario: Home base module is discoverable

- **WHEN** a module under `modules/home/base.nix` declares `flake.modules.homeManager.base`
- **THEN** it is automatically available as `self.modules.homeManager.base`

### Requirement: NixOS and nix-darwin share the same home-manager base

The NixOS and nix-darwin host modules SHALL import the same home-manager base module into `home-manager.sharedModules`. Platform-specific differences SHALL be handled by `mkIf` or by optional platform-specific modules.

#### Scenario: NixOS host applies home base

- **WHEN** a NixOS host imports `roles-base` and enables the home-manager NixOS module
- **THEN** `home-manager.sharedModules` includes `self.modules.homeManager.base`

#### Scenario: Darwin host applies home base

- **WHEN** a nix-darwin host imports `roles-core` and enables the home-manager darwin module
- **THEN** `home-manager.sharedModules` includes `self.modules.homeManager.base`

### Requirement: A standalone home configuration is exposed

The flake SHALL expose a standalone `homeConfigurations.rick` built by `home-manager.lib.homeManagerConfiguration` and using the same base module as the integrated homes.

#### Scenario: Activate standalone home

- **WHEN** a user runs `home-manager switch --flake .#rick` (or equivalent)
- **THEN** the configuration is built from `homeConfigurations.rick`

### Requirement: Standalone home does not depend on NixOS-only options

The standalone `homeConfigurations.rick` SHALL evaluate even when the NixOS-specific `config.environment.sysConf.gui` option is unavailable. Desktop-only conditional settings from the old `home/base.nix` SHALL be omitted or guarded for standalone use.

#### Scenario: Standalone home evaluates

- **WHEN** `home-manager.lib.homeManagerConfiguration` is invoked with `self.modules.homeManager.base`
- **THEN** evaluation succeeds without requiring a NixOS configuration

### Requirement: Desktop home modules are applied to GUI NixOS hosts

The NixOS `system-users` module SHALL include desktop home-manager modules (`dconf`, `terminal`) in `home-manager.sharedModules` when the host enables the GUI environment, so that NixOS desktop users receive the same GNOME and terminal settings as the standalone home configuration.

#### Scenario: NixOS desktop user receives desktop home modules

- **WHEN** a NixOS host imports `roles-desktop`, which sets `environment.sysConf.gui.enable = true`
- **THEN** `home-manager.sharedModules` includes `self.modules.homeManager.dconf` and `self.modules.homeManager.terminal` in addition to `self.modules.homeManager.base`
