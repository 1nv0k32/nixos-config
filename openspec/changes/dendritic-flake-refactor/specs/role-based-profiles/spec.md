# Capability: Role-based profiles

## ADDED Requirements

### Requirement: Roles are named, flat, aspect-oriented modules

The system SHALL provide role modules under `modules/roles/` named `core`, `base`, `server`, `desktop`, `mobile`, `development`, `security`, `media-tools`, and `media-server`. Each role SHALL be exposed as `flake.modules.nixos.roles-<name>` (and as `flake.modules.darwin.roles-<name>` where applicable) and SHALL implement a single, well-named aspect of system configuration.

#### Scenario: Role is discoverable

- **WHEN** a host module imports `self.modules.nixos.roles-desktop`
- **THEN** it enables desktop environment configuration without importing other unrelated concerns

#### Scenario: Roles are flat

- **WHEN** a host module composes a host
- **THEN** it explicitly imports each required role; roles do not implicitly import one another

### Requirement: Current module tiers are replaced by roles

The old `defaultModules`, `baseModules`, `extraModules`, and `guiModules` tiers SHALL be removed. Their contents SHALL be distributed into the new roles as documented in the design.

#### Scenario: Old tier list is gone

- **WHEN** searching for `defaultModules`, `baseModules`, `extraModules`, or `guiModules` in `flake.nix`
- **THEN** no references remain

#### Scenario: GUI module content is preserved

- **WHEN** a host imports `roles-desktop`
- **THEN** it receives the equivalent of the former `guiModules` plus desktop-appropriate system services

### Requirement: Roles compose hosts

Each NixOS or nix-darwin host module under `modules/hosts/` SHALL explicitly import the set of roles it requires, plus a single hardware profile.

#### Scenario: Workstation host

- **WHEN** `modules/hosts/nyx.nix` imports `roles-core`, `roles-base`, `roles-desktop`, `roles-mobile`, `roles-development`, and `roles-security`
- **THEN** the resulting configuration matches the intended feature set for a mobile development workstation

#### Scenario: Server host

- **WHEN** `modules/hosts/nyxpi.nix` imports `roles-core`, `roles-base`, and `roles-server`
- **THEN** the resulting configuration matches the intended feature set for a headless server

### Requirement: Leaf modules are organized by concern

Shared leaf modules that roles compose SHALL live under `modules/programs/`, `modules/services/`, `modules/system/`, and `modules/packages/` based on what they configure.

#### Scenario: Shell aliases live in programs

- **WHEN** a developer looks for shell alias configuration
- **THEN** it is found under `modules/programs/shell.nix` (or equivalent), not in a top-level `modules/shells/` directory
