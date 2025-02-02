{
  inputs,
  stateVersion,
  lib,
  ...
}:
{
  system = {
    stateVersion = stateVersion;
  };

  home-manager = {
    sharedModules = [ (import ../home/base.nix) ];
    extraSpecialArgs = {
      inherit stateVersion;
    };
  };

  environment = {
    etc = {
      "inputrc".text = lib.mkForce (
        builtins.readFile "${inputs.nixpkgs}/nixos/modules/programs/bash/inputrc"
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
