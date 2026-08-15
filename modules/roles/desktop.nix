{ ... }:
{
  flake.modules.nixos.roles-desktop = { self, ... }: {
    imports = [
      self.modules.nixos.services-gnome
      self.modules.nixos.packages-desktop
      self.modules.nixos.system-xdg
      self.modules.nixos.system-ddc
      self.modules.nixos.programs-appimage
      self.modules.nixos.programs-chromium
      self.modules.nixos.programs-gns3
      self.modules.nixos.programs-gpu-screen-recorder
      self.modules.nixos.programs-localsend
      self.modules.nixos.programs-steam
      self.modules.nixos.programs-waydroid
      self.modules.nixos.programs-winbox
      self.modules.nixos.programs-wireshark
      self.modules.nixos.system-printing
      self.modules.nixos.system-fwupd
    ];

    environment.sysConf.gui.enable = true;

    programs.dconf.enable = true;
    services.flatpak.enable = true;
    hardware.logitech.wireless.enable = true;
  };
}
