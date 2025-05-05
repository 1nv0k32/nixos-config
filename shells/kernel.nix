{ pkgs, ... }:
let
  defaultDevShell = prop: {
    nativeBuildInputs =
      with pkgs;
      [
        stdenv.cc.libc
        stdenv.cc.libc.static
        flex
        bison
        bc
        elfutils
        openssl
        pkg-config
        ncurses
        gnumake
        git
        cpio
        qemu
        ctags
        cscope
        gdb
        autoconf
        automake
      ]
      ++ (with pkgs.llvmPackages; [
        llvm
        libllvm
        clang
        clang-tools
        lld
      ]);
    NIX_HARDENING_ENABLE = "";
    shellHook =
      ''
        JOBS=$([[ $(nproc) -gt 4 ]] && echo $(( $(nproc) - 4 )))
        echo "Base make jobs: $JOBS"
        export MAKEFLAGS="--jobs=$JOBS"
      ''
      + prop.shellHook;
  };
in
{
  kernelEnv = pkgs.mkShell (defaultDevShell {
    shellHook = '''';
  });
}
