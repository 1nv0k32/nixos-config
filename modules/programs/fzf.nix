{ ... }:
{
  flake.modules.nixos.programs-fzf = { ... }: {
    programs.fzf = {
      keybindings = true;
      fuzzyCompletion = true;
    };
  };
}
