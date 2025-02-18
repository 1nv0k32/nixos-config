{
  inputs = {
    cfg = {
      url = "github:1nv0k32/nixos-config";
    };
  };

  outputs =
    { cfg, ... }:
    let
      system = "x86_64-linux";
      pkgs = cfg.inputs.nixpkgs.legacyPackages.${system};

      buildJobs = "$([[ $(nproc) -gt 4 ]] && echo $(( $(nproc) - 4 )))";
      defaultDevShell = prop: {
        nativeBuildInputs = with pkgs; [
          stdenv.cc.libc
          stdenv.cc.libc.static
          gnumake
          pkg-config
          ncurses
          git
          cpio
        ];
        inputsFrom = with pkgs; [
          linux
          busybox
        ];
        shellHook = prop.shellHook;
      };
    in
    {
      devShells.${system} = {
        default = pkgs.mkShell (defaultDevShell {
          shellHook = '''';
        });
        initramfs = pkgs.mkShell (defaultDevShell {
          shellHook = ''
            INITRAMFS_DIR=initramfs
            BUSYBOX_DIR=busybox
            mkdir -p $INITRAMFS_DIR/{etc,lib,dev,proc,sys}
            cat <<- EOF > $INITRAMFS_DIR/init
              #!/bin/sh
              mount -t devtmpfs devtmpfs /dev
              mount -t proc none /proc
              mount -t sysfs none /sys
              exec /bin/sh
            EOF
            (
              cd $BUSYBOX_DIR
              JOBS=${buildJobs}
              echo "Building with $JOBS jobs"
              make -j$JOBS
              make CONFIG_PREFIX=../$INITRAMFS_DIR install
            )
            (
              cd $INITRAMFS_DIR
              find . -print | cpio -H newc -o > ../initramfs.img
            )
            exit
          '';
        });
      };
    };
}
