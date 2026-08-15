{ ... }:
{
  flake.modules.nixos.roles-security = { self, ... }: {
    imports = [
      self.modules.nixos.system-yubikey
      self.modules.nixos.system-boot-luks
      self.modules.nixos.packages-security
      self.modules.nixos.programs-sdr
    ];
  };
}
