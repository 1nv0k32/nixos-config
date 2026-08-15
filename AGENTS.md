# Agent Notes

## Repository Overview

### Purpose & Target Systems
- **Purpose**: Declarative NixOS/nix-darwin configuration management using flakes
- **Target Systems**:
  - NixOS hosts (x86_64-linux, aarch64-linux): `nyx`, `nyxpi`, `nyxmac`, `nyxdroid`, `nyxwsl`, `nyxvm`, `nyxutm`, `nyxprl`
  - macOS (nix-darwin): `nyxdarwin`
  - Standalone home-manager configuration for user `rick`

### High-Level Architecture
- **Flake-based**: Uses `flake-parts` for modular flake composition
- **Module auto-discovery**: `import-tree` recursively imports all `.nix` files from `modules/` (except `_lib/` prefix)
- **Namespace organization**: Modules are exposed via `flake.modules.{nixos,darwin,homeManager}.*`
- **Separation of concerns**: Main flake (`flake.nix`) defines configurations; deploy flake (`flakes/flake.nix`) consumes them

## Directory Layout

```
nixos-config/
├── flake.nix                          # Main flake definition (flake-parts + import-tree)
├── flake.lock                         # Flake lock file
├── AGENTS.md                          # This file
├── readme.md                          # Installation instructions
├── .github/workflows/checks_flake.yml # CI: runs `nix flake check` on main + deploy flakes
├── .pre-commit-config.yaml            # Pre-commit hooks (nixfmt)
│
├── flakes/
│   ├── flake.nix                      # Deploy flake: consumes main flake outputs
│   ├── local.nix                      # Local overrides (empty template)
│   ├── checks_local.nix               # CI-only dummy filesystem config
│   └── hardware-configuration.nix     # (optional) Local hardware config
│
└── modules/
    ├── _lib/                          # Helper functions (NOT auto-imported by import-tree)
    │   ├── default.nix
    │   └── nixvim-config.nix
    │
    ├── flake/                         # Flake output definitions (perSystem + flake.*)
    │   ├── nixos-configurations.nix   # Defines flake.nixosConfigurations.*
    │   ├── darwin-configurations.nix  # Defines flake.darwinConfigurations.*
    │   ├── home-config.nix            # Defines flake.homeConfigurations.rick
    │   ├── standalone-home.nix        # Alternative home-manager config
    │   ├── packages.nix               # Defines flake.packages.* (e.g., nvim)
    │   ├── formatter.nix              # Defines flake.formatter
    │   ├── devshells.nix              # Discovers per-shell devShells in modules/devshells/
    │   └── state-version.nix          # Defines flake.lib.stateVersion
    │
    ├── hosts/                         # Host-specific configurations
    │   ├── nyx.nix                    # x86_64-linux desktop
    │   ├── nyxpi.nix                  # aarch64-linux (RPi5) media server
    │   ├── nyxmac.nix                 # aarch64-linux (Apple Silicon) desktop
    │   ├── nyxdroid.nix               # aarch64-linux (Android)
    │   ├── nyxwsl.nix                 # x86_64-linux (WSL)
    │   ├── nyxvm.nix                  # x86_64-linux (QEMU)
    │   ├── nyxutm.nix                 # aarch64-linux (UTM)
    │   ├── nyxprl.nix                 # aarch64-linux (Parallels)
    │   └── nyxdarwin.nix              # aarch64-darwin (macOS)
    │
    ├── roles/                         # Composable role modules
    │   ├── base.nix                   # Base system (users, boot, networking, console, etc.)
    │   ├── core.nix                   # Core tools (shell, git, tmux, fzf, direnv, nixvim, base packages)
    │   ├── desktop.nix                # Desktop (GNOME, packages, XDG, printing, flatpak, etc.)
    │   ├── development.nix            # Dev tools (kubernetes, virtualization, dev packages)
    │   ├── media-tools.nix            # Media tools
    │   ├── media-server.nix           # Media server services
    │   ├── mobile.nix                 # Mobile/Android tools
    │   └── security.nix               # Security tools (yubikey, etc.)
    │
    ├── hardware/                      # Hardware-specific profiles
    │   ├── dummy.nix                  # Minimal filesystem config (used in main flake)
    │   ├── hetzner.nix                # Hetzner Cloud (disko + srvos)
    │   ├── z13g2.nix                  # Lenovo ThinkPad Z13 Gen 2
    │   ├── rpi5.nix                   # Raspberry Pi 5
    │   ├── mac.nix                    # Apple Silicon (nixos-apple-silicon)
    │   ├── wsl.nix                    # Windows Subsystem for Linux
    │   ├── qemu.nix                   # QEMU/KVM
    │   ├── utm.nix                    # UTM (macOS virtualization)
    │   ├── parallels.nix              # Parallels Desktop
    │   └── avf.nix                    # Apple Virtualization Framework
    │
    ├── system/                        # System-level modules
    │   ├── boot.nix                   # Boot configuration
    │   ├── boot-luks.nix              # LUKS encryption
    │   ├── console.nix                # Console settings
    │   ├── ddc.nix                    # Display control
    │   ├── dns.nix                    # DNS configuration
    │   ├── fwupd.nix                  # Firmware updates
    │   ├── hardware.nix               # Hardware detection
    │   ├── logind.nix                 # Logind settings
    │   ├── nix.nix                    # Nix daemon configuration
    │   ├── networking.nix             # Networking
    │   ├── networkd.nix               # systemd-networkd
    │   ├── options.nix                # Custom options (sysConf)
    │   ├── printing.nix               # CUPS printing
    │   ├── source-link.nix            # /etc/nixos symlink
    │   ├── systemd.nix                # systemd settings
    │   ├── time.nix                   # Time/timezone
    │   ├── users.nix                  # User management
    │   ├── virtualization.nix         # KVM/libvirt
    │   ├── xdg.nix                    # XDG directories
    │   └── yubikey.nix                # YubiKey support
    │
    ├── programs/                      # Application-specific modules
    │   ├── appimage.nix               # AppImage support
    │   ├── bash.nix                   # Bash configuration
    │   ├── chromium.nix               # Chromium browser
    │   ├── direnv.nix                 # direnv
    │   ├── fzf.nix                    # Fuzzy finder
    │   ├── git.nix                    # Git configuration
    │   ├── gns3.nix                   # GNS3 network simulator
    │   ├── gpu-screen-recorder.nix    # Screen recording
    │   ├── kube.nix                   # Kubernetes tools
    │   ├── localsend.nix              # Local file sharing
    │   ├── nixvim.nix                 # Neovim (via nixvim)
    │   ├── sdr.nix                    # Software-defined radio
    │   ├── shell.nix                  # Shell configuration
    │   ├── ssh.nix                    # SSH configuration
    │   ├── steam.nix                  # Steam gaming
    │   ├── tmux.nix                   # Tmux multiplexer
    │   ├── waydroid.nix               # Android container
    │   ├── winbox.nix                 # Mikrotik WinBox
    │   ├── wireshark.nix              # Network analyzer
    │   └── zsh.nix                    # Zsh shell
    │
    ├── services/                      # System services
    │   ├── gitea.nix                  # Gitea git service
    │   ├── gnome.nix                  # GNOME desktop environment
    │   ├── k3s.nix                    # Lightweight Kubernetes
    │   ├── media-server.nix           # Media server (Jellyfin, etc.)
    │   ├── postfix.nix                # Mail server
    │   └── wg-server.nix              # WireGuard VPN server
    │
    ├── packages/                      # Package collections
    │   ├── base.nix                   # Base system packages
    │   ├── desktop.nix                # Desktop packages
    │   ├── development.nix            # Development tools
    │   ├── media-tools.nix            # Media tools
    │   ├── overlays.nix               # Nixpkgs overlays
    │   ├── scripts.nix                # Custom scripts
    │   └── security.nix               # Security tools
    │
    ├── home/                          # Home-manager modules
    │   ├── base.nix                   # Base home config (bash, zsh, ssh, git, flameshot)
    │   ├── dconf.nix                  # GNOME dconf settings
    │   ├── terminal.nix               # Terminal emulators (GNOME Terminal, Kitty)
    │   └── bin/backgroud-image.jpg    # Background image
    │
    ├── darwin/                        # macOS-specific modules
    │   └── default.nix                # Base darwin config
    │
    └── devshells/                     # Development shells
        ├── default.nix                # Default devShell
        ├── fhs.nix                    # FHS environment
        ├── go.nix                     # Go development
        ├── kernel.nix                 # Kernel development
        └── python.nix                 # Python development
```

## Flake Outputs & Build Process

### Flake-Parts Architecture
- **Framework**: `flake-parts` provides modular flake composition
- **Module imports** (in `flake.nix`):
  ```nix
  imports = [
    inputs.flake-parts.flakeModules.modules      # Enables flake.modules.* namespace
    inputs.home-manager.flakeModules.home-manager
    inputs.nix-darwin.flakeModules.default
    (inputs.import-tree ./modules)               # Auto-imports all modules/ files
  ];
  ```

### Module Auto-Discovery (import-tree)
- **Behavior**: `import-tree` recursively imports all `.nix` files from `modules/`
- **Exclusion**: Files/directories starting with `_` (e.g., `_lib/`) are NOT auto-imported
- **Module namespace**: Modules define outputs under `flake.modules.{nixos,darwin,homeManager}.*`

### Standard Flake Outputs

#### `flake.nixosConfigurations.*`
- Defined in: `modules/flake/nixos-configurations.nix`
- Hosts: `nyx`, `nyxpi`, `nyxmac`, `nyxdroid`, `nyxwsl`, `nyxvm`, `nyxutm`, `nyxprl`
- Each host composes:
  - `system.stateVersion` (from `flake.lib.stateVersion`)
  - `modules.nixos.hardware-dummy` (fallback filesystem)
  - `modules.nixos.host-{name}` (host-specific config)

#### `flake.darwinConfigurations.*`
- Defined in: `modules/flake/darwin-configurations.nix`
- Host: `nyxdarwin` (aarch64-darwin)
- Composes: `modules.darwin.host-nyxdarwin`

#### `flake.homeConfigurations.*`
- Defined in: `modules/flake/home-config.nix` and `modules/flake/standalone-home.nix`
- User: `rick` (x86_64-linux)
- Modules: `homeManager.base`, `homeManager.dconf`, `homeManager.terminal`

#### `flake.devShells.*`
- Defined in: `modules/devshells/*.nix` (imported via `modules/flake/devshells.nix`)
- Shells: `default`, `fhs`, `go`, `kernel`, `python`

#### `flake.packages.*`
- Defined in: `modules/flake/packages.nix`
- Example: `packages.nvim` (nixvim-based Neovim)

#### `flake.lib.*`
- Defined in: `modules/flake/state-version.nix`
- Exports: `stateVersion = "26.05"`

#### `flake.formatter`
- Defined in: `modules/flake/formatter.nix`
- Tool: `nixfmt-tree`

#### `flake.modules.*` (non-standard, internal)
- Namespace used internally by `flake-parts.flakeModules.modules`
- Exposes: `nixosModules.*`, `darwinModules.*`, `homeModules.*` (standard outputs)
- **Warning**: `nix flake check` warns about unknown output `modules` (benign)

## Host Module Composition

### Host Module Pattern
Each host (e.g., `modules/hosts/nyx.nix`) defines a single flake module:
```nix
{
  flake.modules.nixos.host-nyx = {
    imports = [
      # Upstream modules
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.nixvim.nixosModules.nixvim
      inputs.disko.nixosModules.disko
      inputs.nixos-generators.nixosModules.all-formats

      # Role modules (composable)
      self.modules.nixos.roles-core
      self.modules.nixos.roles-base
      self.modules.nixos.roles-desktop
      self.modules.nixos.roles-mobile
      self.modules.nixos.roles-development
      self.modules.nixos.roles-security

      # Hardware profile
      self.modules.nixos.hardware-z13g2
    ];

    networking.hostName = "nyx";
    networking.domain = "nyxlan.internal";
  };
}
```

### Role + Hardware Composition
- **Roles**: Provide feature sets (base, core, desktop, development, security, media-server, media-tools, mobile, server)
- **Hardware profiles**: Provide hardware-specific config (boot, filesystems, drivers)
- **Flexibility**: Hosts mix and match roles and hardware profiles as needed

### Main Flake vs. Deploy Flake

#### Main Flake (`flake.nix`)
- **Purpose**: Define all modules and outputs
- **Outputs**: `nixosConfigurations`, `darwinConfigurations`, `homeConfigurations`, `devShells`, `packages`, `lib`, `formatter`
- **Module namespace**: Uses `flake.modules.{nixos,darwin,homeManager}.*`
- **Validation**: `nix flake check --no-build` (fast, no builds)

#### Deploy Flake (`flakes/flake.nix`)
- **Purpose**: Lightweight flake for remote deployments (e.g., `nixos-anywhere`)
- **Input**: Consumes main flake as `cfg` input
- **Outputs**: Only `nixosConfigurations` and `darwinConfigurations`
- **Usage**: `nixos-anywhere --flake github:1nv0k32/nixos-config?dir=flakes#TARGET`
- **Local overrides**:
  - `flakes/local.nix` (empty template for local modifications)
  - `flakes/hardware-configuration.nix` (optional hardware config)
  - `flakes/checks_local.nix` (CI-only dummy filesystem)
- **Module access**: Accesses main flake modules via `cfg.modules.nixos.*` and `cfg.modules.darwin.*`
- **StateVersion**: Consumes `cfg.lib.stateVersion` from main flake

### StateVersion Handling
- **Definition**: `modules/flake/state-version.nix` exports `flake.lib.stateVersion = "26.05"`
- **Usage**:
  - Main flake: `self.lib.stateVersion` in `nixosConfigurations`
  - Deploy flake: `cfg.lib.stateVersion` (passed as `specialArgs`)
  - Home-manager: `stateVersion` in `extraSpecialArgs`
- **Rationale**: Avoids creating an unknown flake output; centralizes version management

## Role & Hardware Profile Conventions

### Role Modules (in `modules/roles/`)
- **Naming**: `roles-{name}.nix` → `flake.modules.nixos.roles-{name}`
- **Purpose**: Group related functionality
- **Composition**: Roles import other modules (system, programs, services, packages)
- **Reusability**: Hosts compose multiple roles to build configurations

### Hardware Profiles (in `modules/hardware/`)
- **Naming**: `hardware-{name}.nix` → `flake.modules.nixos.hardware-{name}`
- **Purpose**: Provide hardware-specific config (boot, filesystems, drivers, disko layouts)
- **Examples**:
  - `hardware-dummy.nix`: Minimal fallback (used in main flake)
  - `hardware-z13g2.nix`: Lenovo ThinkPad Z13 Gen 2
  - `hardware-rpi5.nix`: Raspberry Pi 5
  - `hardware-hetzner.nix`: Hetzner Cloud (with disko)
- **Composition**: Hosts import one hardware profile

### System Modules (in `modules/system/`)
- **Naming**: `system-{name}.nix` → `flake.modules.nixos.system-{name}`
- **Purpose**: Configure system-level options (boot, networking, users, nix, etc.)
- **Imported by**: Roles (e.g., `roles-base` imports `system-users`, `system-boot`, etc.)

### Program Modules (in `modules/programs/`)
- **Naming**: `programs-{name}.nix` → `flake.modules.nixos.programs-{name}`
- **Purpose**: Configure individual programs/tools
- **Imported by**: Roles

### Service Modules (in `modules/services/`)
- **Naming**: `services-{name}.nix` → `flake.modules.nixos.services-{name}`
- **Purpose**: Configure system services
- **Imported by**: Roles

### Package Modules (in `modules/packages/`)
- **Naming**: `packages-{name}.nix` → `flake.modules.nixos.packages-{name}`
- **Purpose**: Define package collections
- **Examples**: `packages-base`, `packages-desktop`, `packages-development`, `packages-overlays`

### Home-Manager Modules (in `modules/home/`)
- **Naming**: `{name}.nix` → `flake.modules.homeManager.{name}`
- **Examples**: `base`, `dconf`, `terminal`
- **Usage**: Composed in `homeConfigurations`

### Darwin Modules (in `modules/darwin/`)
- **Naming**: `{name}.nix` → `flake.modules.darwin.{name}`
- **Examples**: `base`, `host-nyxdarwin`

## Key Helper Modules & Options

### `modules/_lib/` (Helper Functions)
- **Purpose**: Shared utilities NOT auto-imported by import-tree
- **Files**:
  - `default.nix`: Placeholder for helper functions
  - `nixvim-config.nix`: Neovim configuration (used in `packages.nvim`)
- **Access**: Import manually in modules that need them

### `modules/flake/` (Flake Output Definitions)
- **Purpose**: Define flake outputs using flake-parts
- **Files**:
  - `nixos-configurations.nix`: Defines `flake.nixosConfigurations.*`
  - `darwin-configurations.nix`: Defines `flake.darwinConfigurations.*`
  - `home-config.nix`: Defines `flake.homeConfigurations.rick`
  - `standalone-home.nix`: Alternative home-manager config
  - `packages.nix`: Defines `flake.packages.*` (perSystem)
  - `formatter.nix`: Defines `flake.formatter` (perSystem)
  - `devshells.nix`: Imports per-shell devShell modules (perSystem)
  - `state-version.nix`: Defines `flake.lib.stateVersion`

### Custom Options (in `modules/system/options.nix`)
- **Namespace**: `environment.sysConf`
- **Purpose**: Custom configuration options for hosts
- **Examples**:
  - `sysConf.user.name`: Username
  - `sysConf.user.sshPubKeys`: SSH public keys
  - `sysConf.server.sshPort`: SSH port
  - `sysConf.gui.enable`: GUI enabled flag
- **Usage**: Accessed in roles and modules

## Validation Commands

### Fast Flake Check (No Builds)
```bash
nix flake check --no-build
```
- Validates flake syntax and module composition
- Does NOT build outputs (fast)
- Expected warnings: `unknown flake output 'modules'` (benign)

### Show All Flake Outputs
```bash
nix flake show
```
- Lists all exported outputs:
  - `nixosConfigurations.{nyx,nyxpi,nyxmac,...}`
  - `darwinConfigurations.nyxdarwin`
  - `homeConfigurations.rick`
  - `devShells.{default,...}`
  - `packages.{nvim,...}`
  - `formatter`
  - `nixosModules.*`, `darwinModules.*`, `homeModules.*`

### Validate Deploy Flake
```bash
cd flakes
nix flake check --no-build
```
- Validates deploy flake separately
- CI runs this with `checks_local.nix` as `local.nix`

### Format Code
```bash
nix fmt
```
- Uses `nixfmt-tree` (defined in `modules/flake/formatter.nix`)
- Pre-commit hook available

## Known Warnings & Why They're Expected

### 1. `warning: unknown flake output 'modules'`
- **Source**: `flake-parts.flakeModules.modules` uses non-standard `modules` output internally
- **Why expected**: The `modules` output is an implementation detail of flake-parts; it provides standard outputs (`nixosModules`, `darwinModules`, `homeModules`)
- **Impact**: Benign; all standard module outputs are produced correctly
- **Why not removed**: Would require migrating all modules off the `flake.modules.*` namespace (large refactor)
- **Suppression**: Not suppressed intentionally

### 2. `evaluation warning: The option \`services.resolved.dnssec' ... has been renamed ...`
- **Source**: Upstream `nixos-avf` module (Apple Virtualization Framework)
- **Why expected**: The upstream module still uses the deprecated `services.resolved.dnssec` option
- **Impact**: Benign; systemd-resolved still functions correctly
- **Why not suppressed**: Intentionally left unsuppressed to track upstream deprecation
- **Mitigation**: Will be resolved when upstream updates

## Deploy Flake Usage

### Overview
The deploy flake (`flakes/flake.nix`) is a lightweight wrapper around the main flake for remote deployments.

### Inputs
```nix
inputs = {
  cfg.url = "github:1nv0k32/nixos-config";  # Main flake
  nixpkgs.follows = "cfg/nixpkgs";
  nix-darwin.follows = "cfg/nix-darwin";
};
```

### Outputs
- **nixosConfigurations**: Built from `cfg.modules.nixos.host-{name}`
- **darwinConfigurations**: Built from `cfg.modules.darwin.host-{name}`
- **No homeConfigurations**: Deploy flake focuses on system configs only

### Module Composition
```nix
mkNixos = host: system:
  nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      self = cfg;
      stateVersion = cfg.lib.stateVersion;
    };
    modules = [
      { system.stateVersion = cfg.lib.stateVersion; }
      cfg.modules.nixos."host-${host}"
    ] ++ localModules;
  };
```

### Local Overrides
- **`flakes/local.nix`**: Template for local modifications (empty by default)
- **`flakes/hardware-configuration.nix`**: Optional hardware config (auto-imported if exists)
- **`flakes/checks_local.nix`**: CI-only dummy filesystem config

### Usage Examples
```bash
# Build a configuration
nix build github:1nv0k32/nixos-config?dir=flakes#nixosConfigurations.nyx

# Deploy with nixos-anywhere
nixos-anywhere --build-on remote --flake github:1nv0k32/nixos-config?dir=flakes#nyx root@HOST

# Local deployment
nixos-rebuild boot --no-write-lock-file --flake github:1nv0k32/nixos-config?dir=flakes#nyx
```

## CI/Workflow Files

### GitHub Actions Workflow (`.github/workflows/checks_flake.yml`)
- **Trigger**: On pull requests and pushes
- **Steps**:
  1. Checkout code
  2. Install Nix
  3. Run `nix flake check` on main flake
  4. Run `nix flake check` on deploy flake (with `checks_local.nix` as `local.nix`)
- **Note**: Deploy flake check uses `|| true` (allows failure)

### Pre-Commit Configuration (`.pre-commit-config.yaml`)
- **Hooks**:
  - `nixfmt`: Format Nix code (`nix fmt`)
  - `check-yaml`: Validate YAML files
  - `end-of-file-fixer`: Ensure files end with newline
  - `trailing-whitespace`: Remove trailing whitespace

## Gotchas & Important Notes for Agents

### Module Naming & Namespacing
- **Convention**: Module files define outputs under `flake.modules.{nixos,darwin,homeManager}.*`
- **Naming**: File `foo.nix` in `modules/roles/` → `flake.modules.nixos.roles-foo`
- **Hyphens**: Hyphens in filenames become hyphens in module names (e.g., `roles-base`, `programs-bash`)

### StateVersion Management
- **Single source of truth**: `modules/flake/state-version.nix` defines `flake.lib.stateVersion`
- **Propagation**: Automatically passed to all configurations via `specialArgs`
- **Deploy flake**: Accesses via `cfg.lib.stateVersion` (no hardcoding)
- **Update process**: Change value in `state-version.nix`; propagates everywhere

### Import-Tree Behavior
- **Auto-import**: All `.nix` files in `modules/` are recursively imported
- **Exclusion**: Files/dirs starting with `_` are skipped (e.g., `_lib/`)
- **Naming**: File path becomes module identifier (e.g., `modules/roles/base.nix` → `modules.roles-base`)
- **No explicit imports needed**: Just create a `.nix` file in the right directory

### Home-Manager Integration
- **Two approaches**:
  1. `modules/flake/home-config.nix`: Standalone `homeConfigurations.rick`
  2. `modules/flake/standalone-home.nix`: Alternative standalone config
- **Modules**: Home-manager modules in `modules/home/` are auto-discovered
- **SpecialArgs**: `stateVersion` and `gui.enable` passed to home-manager

### Darwin-Specific Notes
- **Base module**: `modules/darwin/default.nix` provides base darwin config
- **StateVersion**: Uses `system.stateVersion = 6` (nix-darwin format, not NixOS)
- **Home-manager**: Integrated via `home-manager.darwinModules.home-manager`
- **Host module**: `modules/hosts/nyxdarwin.nix` defines `flake.modules.darwin.host-nyxdarwin`

### Hardware Profile Fallback
- **Main flake**: Always includes `modules.nixos.hardware-dummy` as fallback
- **Purpose**: Provides minimal filesystem config for hosts without specific hardware profile
- **Deploy flake**: Uses `checks_local.nix` (CI-only) for the same purpose

### Disko Integration
- **Purpose**: Declarative disk partitioning and formatting
- **Usage**: Hardware profiles (e.g., `hardware-hetzner.nix`) define `disko.devices`
- **Modules**: Imported via `inputs.disko.nixosModules.disko`

### Overlays
- **Location**: `modules/packages/overlays.nix`
- **Purpose**: Customize nixpkgs packages
- **Usage**: Imported by roles (e.g., `roles-core` imports `packages-overlays`)

### Custom Options
- **Location**: `modules/system/options.nix`
- **Namespace**: `environment.sysConf`
- **Access**: Available in all modules via `config.environment.sysConf`
- **Examples**: User name, SSH keys, server port, GUI flag

### Editing Modules
- **Add new module**: Create `.nix` file in appropriate directory (e.g., `modules/programs/foo.nix`)
- **Define output**: Use `flake.modules.nixos.programs-foo = { ... }`
- **Import in host**: Add to host's imports list (e.g., `self.modules.nixos.programs-foo`)
- **No flake.nix changes needed**: import-tree auto-discovers the new module

### Testing Changes
```bash
# Fast validation (no builds)
nix flake check --no-build

# Show all outputs
nix flake show

# Build a specific configuration
nix build .#nixosConfigurations.nyx.config.system.build.toplevel

# Evaluate without building
nix eval .#nixosConfigurations.nyx --no-build
```

### Common Pitfalls
- **Forgetting `self.` prefix**: Use `self.modules.nixos.*` in module imports, not just `modules.nixos.*`
- **Wrong module namespace**: NixOS modules use `flake.modules.nixos.*`, not `flake.modules.*`
- **StateVersion mismatch**: Always use `self.lib.stateVersion` or `cfg.lib.stateVersion`; don't hardcode
- **Editing _lib files**: Changes to `modules/_lib/` require manual imports; they're not auto-discovered
- **Flake lock**: Run `nix flake update` to update `flake.lock` after changing inputs
