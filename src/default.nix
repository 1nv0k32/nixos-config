{
  modulesPath,
  stateVersion,
  lib,
  ...
}:
{
  system = {
    stateVersion = stateVersion;
  };

  fileSystems."/" = lib.mkDefault {
    device = "none";
  };

  environment = {
    etc = {
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
