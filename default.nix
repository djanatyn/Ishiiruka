{ sources ? import ./nix/sources.nix, mesa_drivers, mesa_glu, mesa, pkgconfig
, bluez, ffmpeg, libao, libGLU, gtk2, gtk3, glib, gettext, xorg, readline
, openal, libevdev, portaudio, libusb, libpulseaudio, libudev, gnumake, wxGTK31
, gdk-pixbuf, soundtouch, miniupnpc, mbedtls, curl, lzo, sfml, enet, xdg_utils
, hidapi }:
with rec {
  overlay = _: pkgs: { niv = import sources.niv { }; };
  pkgs = import sources.nixpkgs { overlays = [ overlay ]; };
};
pkgs.stdenv.mkDerivation rec {
  pname = "slippi-ishiiruka";
  version = "2.2.1";
  name = "${pname}-${version}";
  src = builtins.path {
    path = ./.;
    inherit name;
  };

  cc = pkgs.gcc;

  gtk2 = pkgs.gtk2;
  glib = pkgs.glib;

  enableParallelBuilding = true;
  outputs = [ "out" ];
  makeFlags = [ "VERSION=us" "-s" "VERBOSE=1" ];
  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DLINUX_LOCAL_DEV=true"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_INCLUDE_DIRS=${gtk2.out}/lib/gtk-2.0"
    "-DENABLE_LTO=True"
  ];

  installPhase = ''
    touch Binaries/portable.txt
    cp -r -n ../Data/Sys/ Binaries/
    cp -r Binaries/ $out
    mkdir -p $out/bin && ln -s $out/dolphin-emu $out/bin/slippi-netplay
  '';

  nativeBuildInputs = with pkgs; [ pkgconfig cmake ];
  buildInputs = with pkgs; [
    mesa_drivers
    mesa_glu
    mesa
    pkgconfig
    bluez
    ffmpeg
    libao
    libGLU
    gtk2
    gtk3
    glib
    gettext
    xorg.libpthreadstubs
    xorg.libXrandr
    xorg.libXext
    xorg.libX11
    xorg.libSM
    readline
    openal
    libevdev
    xorg.libXdmcp
    portaudio
    libusb
    libpulseaudio
    libudev
    gnumake
    wxGTK31
    gdk-pixbuf
    soundtouch
    miniupnpc
    mbedtls
    curl
    lzo
    sfml
    enet
    xdg_utils
    hidapi
  ];
}
