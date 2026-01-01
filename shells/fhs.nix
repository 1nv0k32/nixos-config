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
    profile = ''
      export PYTHONPATH=${pkgs.platformio}/lib/python3.12/site-packages:$PYTHONPATH
    '';
    runScript = ''
      ${pkgs.zsh}/bin/zsh
    '';
  };
}
