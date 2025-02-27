{ pkgs, ... }:
let
  defaultDevShell = prop: {
    nativeBuildInputs = with pkgs; [
      stdenv.cc.libc
      stdenv.cc.libc.static
      gnumake
      pkg-config
      ncurses
      git
      cpio
      qemu
      ctags
    ];
    inputsFrom = with pkgs; [
      linux
      busybox
    ];
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
    shellHook = ''
      echo "Default kernel shell"
    '';
  });
  kernelRun = pkgs.mkShell (defaultDevShell {
    shellHook = ''
      qemu-system-x86_64 \
        -kernel linux/arch/x86/boot/bzImage \
        -initrd initramfs.img \
        -enable-kvm -machine pc-q35-7.1 \
        -m 2G -smp 2,sockets=2,cores=1 \
        -net nic,model=e1000 \
        -nographic -serial mon:stdio -append 'console=ttyS0'
      exit
    '';
  });
  kernelInitramfs = pkgs.mkShell (defaultDevShell {
    shellHook = ''
      INITRAMFS_DIR=initramfs
      BUSYBOX_DIR=busybox
      LINUX_DIR=linux
      mkdir -p $INITRAMFS_DIR/{etc,lib,dev,proc,sys}
      cat <<-EOF > $INITRAMFS_DIR/init
      #!/bin/sh
      mount -t devtmpfs devtmpfs /dev
      mount -t proc none /proc
      mount -t sysfs none /sys
      exec /bin/sh
      EOF
      chmod +x $INITRAMFS_DIR/init
      (
        cd $BUSYBOX_DIR
        make
        make CONFIG_PREFIX=../$INITRAMFS_DIR install
      )
      (
        cd $LINUX_DIR
        make INSTALL_MOD_PATH=../$INITRAMFS_DIR modules_install
      )
      (
        cd $INITRAMFS_DIR
        find . -print | cpio -H newc -o > ../initramfs.img
      )
      exit
    '';
  });
}
