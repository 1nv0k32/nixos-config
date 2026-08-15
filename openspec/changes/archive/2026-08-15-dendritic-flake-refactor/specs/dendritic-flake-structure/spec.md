# Capability: Dendritic flake structure

## ADDED Requirements

### Requirement: flake.nix uses flake-parts

The main `flake.nix` SHALL use `flake-parts.lib.mkFlake` as the top-level output builder and SHALL import `flake-parts.flakeModules.modules` to enable the `flake.modules.*` option namespace.

#### Scenario: flake metadata

- **WHEN** a user runs `nix flake metadata` on the repository root
- **THEN** the flake evaluates without error and exposes the expected outputs

#### Scenario: flake-parts modules option is available

- **WHEN** a module under `modules/` sets `flake.modules.nixos.foo = { ... }`
- **THEN** the flake output includes `nixosModules.foo`

### Requirement: Modules are auto-discovered via import-tree

The flake SHALL use `import-tree` to recursively import every `.nix` file under `modules/` as a flake-parts module, except paths containing `/_` which SHALL be ignored.

#### Scenario: Adding a new role module

- **WHEN** a developer creates `modules/roles/foobar.nix` that declares `flake.modules.nixos.roles-foobar`
- **THEN** the module is automatically available as `self.modules.nixos.roles-foobar` without editing `flake.nix`

#### Scenario: Helper directories are ignored

- **WHEN** a developer adds a helper file at `modules/_lib/helpers.nix`
- **THEN** `import-tree` does not import it as a flake-parts module

### Requirement: Flake outputs are declared from modules

Packages, development shells, formatter, and `nixosConfigurations`/`darwinConfigurations`/`homeConfigurations` SHALL be declared from modules under `modules/flake/`, `modules/packages/`, `modules/devshells/`, and `modules/hosts/` rather than inline in `flake.nix`.

#### Scenario: Formatter is exposed

- **WHEN** a user runs `nix fmt`
- **THEN** the formatter configured in `modules/flake/formatter.nix` is used

#### Scenario: Dev shells are exposed

- **WHEN** a user runs `nix develop .#python`
- **THEN** the shell configured in `modules/devshells/` is used

### Requirement: Old top-level module directories are removed

After migration, the top-level directories `src/`, `home/`, `pkgs/`, `system/`, `overrides/`, `shells/`, and the old contents of `modules/gui/`, `modules/etc/`, `modules/shells/`, and `modules/tools/` SHALL no longer exist; their content SHALL have moved into the dendritic `modules/` tree.

#### Scenario: No stale module files remain

- **WHEN** the migration is complete
- **THEN** `find src home pkgs system overrides shells -name '*.nix' 2>/dev/null` returns no files
