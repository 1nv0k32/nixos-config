{ modulesPath, lib, ... }:
{
  INPUTRC_CONFIG = lib.mkForce (
    builtins.readFile "${modulesPath}/programs/bash/inputrc"
    + ''
      set completion-ignore-case on
      set colored-completion-prefix on
      set skip-completed-text on
      set visible-stats on
      set colored-stats on
      set mark-symlinked-directories on
    ''
  );
}
