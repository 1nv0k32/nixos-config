{ pkgs, ... }:
let
  pythonWithPIO = pkgs.python3.withPackages (ps: [ pkgs.platformio ]);
in
{
  shell = pkgs.buildFHSEnv {
    name = "platformio-fhs";
    runScript = "env LD_LIBRARY_PATH= ${pkgs.zsh}/bin/zsh";
    targetPkgs =
      pkgs:
      (with pkgs; [
        platformio-core
        openocd
        pythonWithPIO
      ]);
  };
}
