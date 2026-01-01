{ pkgs, ... }:
let
  pythonWithPIO =
    pks:
    pks.python312.withPackages (
      ps: with ps; [
        pks.platformio-core
        pylibftdi
        pyusb
      ]
    );
in
{
  shell = pkgs.buildFHSEnv {
    name = "platformio-fhs";
    targetPkgs =
      pkgs:
      (with pkgs; [
        zsh
        platformio-core
        openocd
        arduino-cli
        avrdude
        libftdi
        libftdi1
        libusb1
        (pythonWithPIO pkgs)
      ]);
    runScript = ''
      ${pkgs.zsh}/bin/zsh
    '';
  };
}
