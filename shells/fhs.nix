{ pkgs, ... }:
let
  pythonWithPIO =
    pks:
    pks.python312.withPackages (
      ps: with ps; [
        pylibftdi
        pyusb
      ]
    );
in
{
  shell = pkgs.buildFHSEnv {
    name = "platformio-fhs";
    runScript = "${pkgs.zsh}/bin/zsh";
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
  };
}
