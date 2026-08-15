# Agent Notes

## Validation

- Run a fast evaluation check with:
  ```bash
  nix flake check --no-build
  ```
- `nix flake show` lists all exported outputs (including `nixosConfigurations`, `darwinConfigurations`, `homeConfigurations`, `devShells`, `nixosModules`, `homeModules`, `darwinModules`, etc.).

## Known `nix flake check` warnings

1. `warning: unknown flake output 'modules'`
   - This is emitted because the flake imports `flake-parts.flakeModules.modules`, which uses a non-standard `modules` output internally to provide `nixosModules`, `homeModules`, and `darwinModules`. The warning is benign and the standard module outputs are still produced correctly.
   - Removing it cleanly would require migrating all modules off the `flake.modules.*` namespace, which is a larger refactor.

2. `evaluation warning: The option \`services.resolved.dnssec' ... has been renamed ...`
   - This originates in the upstream `nixos-avf` module, which still sets the old `services.resolved.dnssec` option. It is intentionally not suppressed in this repo.

## Project conventions

- `stateVersion` is exposed as `flake.lib.stateVersion` (e.g. `self.lib.stateVersion`) so it can be consumed by host modules and the deploy flake without creating an unknown flake output.
- The deploy flake (`flakes/flake.nix`) consumes the main flake via `cfg.lib.stateVersion` and `cfg.modules.nixos.*` / `cfg.modules.darwin.*`.
- Module tree is auto-discovered by `(inputs.import-tree ./modules)`; files under `modules/_lib/` are not auto-imported.
