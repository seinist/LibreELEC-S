# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="sdl2"
PKG_VERSION="2.0.20"
PKG_SHA256="2a026753af9b03fca043824bca8341f74921a836d28729e0c31aa262202a83c6"
PKG_LICENSE="SDL"
PKG_SITE="https://www.libsdl.org/"
PKG_URL="https://github.com/libsdl-org/SDL/archive/refs/tags/release-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain alsa-lib systemd dbus"
PKG_LONGDESC="Simple DirectMedia Layer is a cross-platform development library for portable low-level access to a video framebuffer, audio output, mouse, and keyboard."

configure_package() {
  # Apply project specific patches
  PKG_PATCH_DIRS+=" ${PROJECT}"

  # Assembly support for x86_64
  if [ "${TARGET_ARCH}" = "x86_64" ]; then
    PKG_DEPENDS_TARGET+=" nasm:host"
  fi

  # X11 support
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_DEPENDS_TARGET+=" libX11 libXrandr"
  fi

  # Wayland support
  if [ "${DISPLAYSERVER}" = "wl" ]; then
    PKG_DEPENDS_TARGET+=" wayland"
  fi

  # OpenGL support
  if [ "${OPENGL_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGL}"
  fi

  # OpenGLES support
  if [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGLES}"
  fi

  # Vulkan support
  if [ "${VULKAN_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${VULKAN}"
  fi

  # Pulseaudio support
  if [ "${PULSEAUDIO_SUPPORT}" = yes ]; then
    PKG_DEPENDS_TARGET+=" pulseaudio"
  fi
}

pre_configure_target(){
  PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=ON \
                         -DSDL_3DNOW=OFF \
                         -DSDL_ALSA=ON \
                         -DSDL_ALSA_SHARED=ON \
                         -DSDL_ALTIVEC=OFF \
                         -DSDL_ARTS=OFF \
                         -DSDL_ARTS_SHARED=OFF \
                         -DSDL_ASAN=OFF \
                         -DSDL_BACKGROUNDING_SIGNAL=OFF \
                         -DSDL_CLOCK_GETTIME=OFF \
                         -DSDL_COCOA=OFF \
                         -DSDL_DIRECTFB=OFF \
                         -DSDL_DIRECTFB_SHARED=OFF \
                         -DSDL_DIRECTX=OFF \
                         -DSDL_DISKAUDIO=OFF \
                         -DSDL_DUMMYAUDIO=OFF \
                         -DSDL_DUMMYVIDEO=OFF \
                         -DSDL_ESD=OFF \
                         -DSDL_ESD_SHARED=OFF \
                         -DSDL_FOREGROUNDING_SIGNAL=OFF \
                         -DSDL_FUSIONSOUND=OFF \
                         -DSDL_FUSIONSOUND_SHARED=OFF \
                         -DSDL_GCC_ATOMICS=ON \
                         -DSDL_HIDAPI_JOYSTICK=OFF \
                         -DSDL_JACK=OFF \
                         -DSDL_JACK_SHARED=OFF \
                         -DSDL_LIBC=ON \
                         -DSDL_LIBSAMPLERATE=OFF \
                         -DSDL_LIBSAMPLERATE_SHARED=OFF \
                         -DSDL_METAL=OFF \
                         -DSDL_NAS=OFF \
                         -DSDL_NAS_SHARED=OFF \
                         -DSDL_OFFSCREEN=OFF \
                         -DSDL_OSS=OFF \
                         -DSDL_PIPEWIRE=OFF \
                         -DSDL_PIPEWIRE_SHARED=OFF \
                         -DSDL_PTHREADS=ON \
                         -DSDL_PTHREADS_SEM=ON \
                         -DSDL_RENDER_D3D=OFF \
                         -DSDL_RENDER_METAL=OFF \
                         -DSDL_RPATH=OFF \
                         -DSDL_SNDIO=OFF \
                         -DSDL_SNDIO_SHARED=OFF \
                         -DSDL_SSEMATH=OFF \
                         -DSDL_STATIC_PIC=OFF \
                         -DSDL_TEST=OFF \
                         -DSDL_VIRTUAL_JOYSTICK=OFF \
                         -DSDL_VIVANTE=OFF \
                         -DSDL_WASAPI=OFF \
                         -DSDL_WAYLAND_LIBDECOR=OFF \
                         -DSDL_WAYLAND_LIBDECOR_SHARED=OFF \
                         -DSDL_WAYLAND_QT_TOUCH=OFF \
                         -DSDL_XINPUT=OFF"

  # Pulseaudio Support
  if [ "${PULSEAUDIO_SUPPORT}" = yes ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_PULSEAUDIO=ON \
                             -DSDL_PULSEAUDIO_SHARED=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_PULSEAUDIO=OFF \
                             -DSDL_PULSEAUDIO_SHARED=OFF"
  fi

  # Displayserver
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_X11=ON \
                             -DSDL_X11_SHARED=ON \
                             -DSDL_X11_XCURSOR=OFF \
                             -DSDL_X11_XDBE=OFF \
                             -DSDL_X11_XFIXES=OFF \
                             -DSDL_X11_XINERAMA=OFF \
                             -DSDL_X11_XINPUT=OFF \
                             -DSDL_X11_XRANDR=ON \
                             -DSDL_X11_XSCRNSAVER=OFF \
                             -DSDL_X11_XSHAPE=OFF \
                             -DSDL_X11_XVM=OFF \
                             -DSDL_WAYLAND=OFF"

  elif [ "${DISPLAYSERVER}" = "wl" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_WAYLAND=ON \
                             -DSDL_WAYLAND_SHARED=ON \
                             -DSDL_X11=OFF"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_WAYLAND=OFF \
                             -DSDL_WAYLAND_SHARED=OFF \
                             -DSDL_X11=OFF"
  fi

  # KMSDRM Support
  if [ "${OPENGLES}" = "mesa" ] || [ "${OPENGL}" = "mesa" ] || [ "${OPENGLES}" = "libmali" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_KMSDRM_SHARED=ON \
                             -DSDL_KMSDRM=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_KMSDRM_SHARED=OFF \
                             -DSDL_KMSDRM=OFF"
  fi

  # OpenGL Support
  if [ "${OPENGL_SUPPORT}" = "yes" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_OPENGL=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_OPENGL=OFF"
  fi

  # OpenGLES Support
  if [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_OPENGLES=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_OPENGLES=OFF"
  fi

  # RPi Video Support
  if [ "${OPENGLES}" = "bcm2835-driver" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_RPI=ON \
                             -DSDL_VULKAN=OFF \
                             -DSDL_KMSDRM=OFF"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_RPI=OFF"
  fi

  # Vulkan Support
  if [ "${VULKAN_SUPPORT}" = "yes" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_VULKAN=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_VULKAN=OFF"
  fi

  # MMX Support
  if target_has_feature mmx; then
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_MMX=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_MMX=OFF"
  fi

  # NEON Support
  if target_has_feature neon; then
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_ARMNEON=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_ARMNEON=OFF"
  fi

  # SSE Support
  if target_has_feature sse; then
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_SSE=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_SSE=OFF"
  fi

  # SSE2 Support
  if target_has_feature sse2; then
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_SSE2=ON"
  else
    PKG_CMAKE_OPTS_TARGET+=" -DSDL_SSE2=OFF"
  fi
}

post_makeinstall_target() {
  # fix config
  sed -e "s:\(['=\" ]\)/usr:\\1${SYSROOT_PREFIX}/usr:g" -i ${SYSROOT_PREFIX}/usr/bin/sdl2-config

  # clean up
  safe_remove ${INSTALL}/usr/bin
}
