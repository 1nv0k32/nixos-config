{ ... }:
{
  flake.modules.nixos.roles-core = { self, ... }: {
    imports = [
      self.modules.nixos.packages-overlays
      self.modules.nixos.system-nix
      self.modules.nixos.system-options
      self.modules.nixos.programs-bash
      self.modules.nixos.programs-zsh
      self.modules.nixos.programs-shell
      self.modules.nixos.programs-git
      self.modules.nixos.programs-ssh
      self.modules.nixos.programs-tmux
      self.modules.nixos.programs-fzf
      self.modules.nixos.programs-direnv
      self.modules.nixos.programs-nixvim
      self.modules.nixos.packages-base
      self.modules.nixos.packages-scripts
    ];
  };
}
