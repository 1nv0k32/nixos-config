{ pkgs, ... }:
let
  pythonWithPIO = pkgs.python3.withPackages (ps: with ps; [ platformio ]);
in
{
  shell = pkgs.buildFHSEnv {
    name = "platformio-fhs";
    runScript = "env LD_LIBRARY_PATH= bash";
    targetPkgs =
      pkgs:
      (with pkgs; [
        platformio-core
        openocd
        pythonWithPIO
      ]);
  };
}
