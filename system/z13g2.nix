{ lib, ... }:
{
  boot = {
    extraModprobeConfig = ''
      options kvm_amd nested=1
      options hid_apple fnmode=0
    '';
  };

  environment.variables = {
    "VDPAU_DRIVER" = "radeonsi";
    "LIBVA_DRIVER_NAME" = "radeonsi";
  };

  services = {
    fprintd.enable = lib.mkForce false;
    power-profiles-daemon.enable = lib.mkForce false;
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 90;
        STOP_CHARGE_THRESH_BAT0 = 100;
        CPU_BOOST_ON_BAT = 0;
      };
    };
  };
}
