{
  self,
  ...
}:
{
  imports = [
    (import ./disko.nix)
    (import "${self}/modules/etc/stirling-pdf.nix")
  ];

  boot = {
    extraModprobeConfig = ''
      options kvm_amd nested=1
    '';
    binfmt.emulatedSystems = [
      "x86_64-windows"
      "aarch64-linux"
    ];
  };

  hardware = {
    alsa.enablePersistence = true;
  };

  environment.variables = {
    "VDPAU_DRIVER" = "radeonsi";
    "LIBVA_DRIVER_NAME" = "radeonsi";
  };

  services = {
    fprintd.enable = true;
  };
}
