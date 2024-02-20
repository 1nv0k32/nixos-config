{ pkgs }:
with pkgs;
{
  CONSOLE = [
    terminus_font
  ];

  FONT = [
    ubuntu_font_family
    vazir-fonts
  ];

  USER = [
    chromium
    firefox
    spotify
    flameshot
    otpclient
    winbox
    gns3-gui
    gns3-server
    dynamips
    inetutils
    pavucontrol
    networkmanagerapplet
    imagemagick
    ghostscript
    ffmpeg
    vlc
    gimp
    evince
    rivalcfg
    discord
    transmission
    transmission-gtk
    pulseaudio
    unrar-wrapper
    cobang
    alsa-utils
    ghidra-bin
    rpi-imager
    yt-dlp
    media-downloader
    pass

    gnome.gnome-terminal
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnome.nautilus
    gnome.file-roller
    gnome.gnome-calculator
    gnome.eog
  ];

  GNOME_EXT = [
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    gnomeExtensions.unblank
    gnomeExtensions.tiling-assistant
    gnomeExtensions.caffeine
  ];

  SYSTEM = [
    nixos-generators
    vim_configurable
    cryptsetup
    openssl
    git
    tmux
    bat
    nixpkgs-fmt
    tree
    file
    htop
    acpi
    efibootmgr
    nload
    ncdu
    aria
    wget
    unzip
    tpm2-tss
    jq
    yq

    ntfs3g
    gnumake
    cmake
    libgcc
    glibc
    gcc
    gdb
    valgrind
    android-tools

    wireguard-tools
    conntrack-tools
    nftables
    openvpn
    ubridge
    iw

    nixopsUnstable
    kubectl
    kubernetes-helm
    k9s
    argocd
    awscli
    vscode
    virt-manager
    win-virtio
    vagrant
    terraform
    ansible
    podman-compose
    distrobox
    quickemu
    git-crypt
    kind

    nvme-cli
    gparted
    stress
    pwgen
    qrencode
    usbutils
    pciutils

    nmap
    burpsuite
    radare2
    pwntools
    pwndbg
    aircrack-ng
    binwalk

    poetry
    hatch

    stm32cubemx
    stm32loader
    stm32flash

    wl-clipboard
    wineWowPackages.stable
  ];
}

# vim:expandtab ts=2 sw=2
