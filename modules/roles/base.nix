{ ... }:
{
  flake.modules.nixos.roles-base = { self, ... }: {
    imports = [
      self.modules.nixos.system-users
      self.modules.nixos.system-boot
      self.modules.nixos.system-networking
      self.modules.nixos.system-console
      self.modules.nixos.system-logind
      self.modules.nixos.system-systemd
      self.modules.nixos.system-time
      self.modules.nixos.system-hardware
      self.modules.nixos.system-source-link
    ];
  };
}
