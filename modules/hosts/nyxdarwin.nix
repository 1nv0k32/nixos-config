{
  inputs,
  self,
  ...
}:
{
  flake.modules.darwin.host-nyxdarwin = {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      inputs.nixvim.nixDarwinModules.nixvim
      self.modules.darwin.base
      self.modules.nixos.packages-overlays
      self.modules.nixos.packages-base
      self.modules.nixos.programs-bash
      self.modules.nixos.programs-chromium
    ];

    networking.hostName = "nyxdarwin";
    networking.domain = null;

    home-manager = {
      sharedModules = [ self.modules.homeManager.base ];
      extraSpecialArgs = {
        stateVersion = self.stateVersion;
        gui = { enable = false; };
      };
      users.rick = { ... }: {
        home.username = "rick";
        programs.git.settings.user = {
          name = "Armin Mahdilou";
          email = "Armin.Mahdilou@gmail.com";
        };
      };
    };
  };
}
