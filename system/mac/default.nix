{ ... }:
{
  boot = {
    extraModprobeConfig = ''
      options hid_apple fnmode=3 iso_layout=-1 swap_fn_leftctrl=1 swap_opt_cmd=1
    '';
  };

  boot.loader.efi.canTouchEfiVariables = false;
  networking.networkmanager.enable = true;
}
