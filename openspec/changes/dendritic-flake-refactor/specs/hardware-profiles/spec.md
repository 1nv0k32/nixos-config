# Capability: Hardware profiles

## ADDED Requirements

### Requirement: Hardware profiles are separate from roles

The system SHALL provide machine-type-specific modules under `modules/hardware/` for each supported platform: `z13g2`, `mac`, `hetzner`, `rpi5`, `avf`, `wsl`, `qemu`, `utm`, and `parallels`. Each profile SHALL be exposed as `flake.modules.nixos.hardware-<name>` (or `flake.modules.darwin.hardware-mac` for nix-darwin where applicable).

#### Scenario: Hardware profile is selected per host

- **WHEN** a host module for `nyx` imports `self.modules.nixos.hardware-z13g2`
- **THEN** the configuration includes the Lenovo ThinkPad Z13 Gen2 hardware support and any machine-specific tweaks

#### Scenario: Roles remain machine-agnostic

- **WHEN** a developer inspects `modules/roles/`
- **THEN** no role contains machine-specific hardware configuration such as kernel modules for a particular laptop

### Requirement: Each NixOS host imports exactly one hardware profile

Every NixOS host module SHALL import exactly one hardware profile. The profile SHALL encapsulate all machine-specific inputs, modules, and disk configuration.

#### Scenario: Single hardware import

- **WHEN** a static analysis tool counts hardware module imports in a host module
- **THEN** exactly one `hardware-*` module is imported

### Requirement: Disk partitioning lives in the hardware profile

Where a machine type uses `disko`, the disko configuration SHALL be imported from the corresponding hardware profile, not from the host module or a role.

#### Scenario: Z13G2 disk layout

- **WHEN** the `hardware-z13g2` module is imported
- **THEN** the corresponding disk layout module is loaded automatically

### Requirement: A dummy hardware profile exists for CI

The system SHALL provide `modules/hardware/dummy.nix` that defines a minimal root filesystem with `lib.mkDefault`, enabling the main flake to build `nixosConfigurations` in CI without real per-machine `hardware-configuration.nix` files.

#### Scenario: Main flake check

- **WHEN** a user runs `nix flake check` on the main flake
- **THEN** every `nixosConfigurations.<host>` evaluates successfully using the dummy hardware profile

#### Scenario: Deploy flake overrides dummy

- **WHEN** the deploy flake imports a host module from the main flake and appends its real `hardware-configuration.nix`
- **THEN** the real configuration overrides the dummy root filesystem
