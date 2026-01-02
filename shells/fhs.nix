{ pkgs, ... }:
{
  shell = pkgs.buildFHSEnv {
    name = "platformio-fhs";
    targetPkgs =
      pkgs:
      (with pkgs; [
        python312
        zsh
        platformio-core
        openocd
        arduino-cli
        avrdude
        libftdi
        libftdi1
        libusb1
      ]);
    runScript = ''
      ${pkgs.zsh}/bin/zsh
    '';
  };
}
