{
  self,
  modulesPath,
  lib,
  ...
}:
{
  imports = [
    (import ./libs/nix.nix)
    (import ./users.nix)
  ];

  system = {
    stateVersion = self.stateVersion;
  };

  environment = {
    etc = {
      "nixos/flake.nix" = {
        source = "${self}/flakes/flake.nix";
        mode = "0444";
      };
      "inputrc".text = lib.mkForce (
        builtins.readFile "${modulesPath}/programs/bash/inputrc"
        + ''
          set completion-ignore-case on
          set colored-completion-prefix on
          set skip-completed-text on
          set visible-stats on
          set colored-stats on
          set mark-symlinked-directories on
          set show-all-if-ambiguous on
        ''
      );
    };
  };
}
