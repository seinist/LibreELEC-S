# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="retroarch"
PKG_VERSION="de4e56ecf28a09057734f8624af6d62f3088734f" #v1.10.2
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://github.com/libretro/RetroArch"
PKG_URL="https://github.com/libretro/RetroArch.git"
PKG_DEPENDS_TARGET="toolchain linux glibc systemd dbus openssl expat alsa-lib libpng libusb libass speex flac-system tinyalsa fluidsynth-system freetype zlib bzip2 ffmpeg common-overlays-lr core-info-lr database-lr glsl-shaders-lr overlay-borders-lr samples-lr retroarch-assets retroarch-joypad-autoconfig libxkbcommon"
PKG_LONGDESC="Reference frontend for the libretro API."
GET_HANDLER_SUPPORT="git"
PKG_BUILD_FLAGS="+lto"

configure_package() {
  # SAMBA Support
  if [ "${SAMBA_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" samba"
  fi

  # AVAHI Support
  if [ "${AVAHI_DAEMON}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" avahi nss-mdns"
  fi

  # Pulseaudio Support
  if [ "${PULSEAUDIO_SUPPORT}" = yes ]; then
    PKG_DEPENDS_TARGET+=" pulseaudio"
  fi

  # Displayserver Support
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_DEPENDS_TARGET+=" xorg-server unclutter-xfixes"
  fi

  # Build with OpenGL / OpenGLES support
  if [ "${OPENGL_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGL}"
  elif [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${OPENGLES}"
  fi

  # Vulkan Support
  if [ "${VULKAN_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" ${VULKAN} slang-shaders-lr"
  fi
}

pre_configure_target() {
  # Change to build dir
  cd ${PKG_BUILD}

  # Export pkg-config path
  export PKG_CONF_PATH=${TOOLCHAIN}/bin/pkg-config

  # Clear buildchain args
  TARGET_CONFIGURE_OPTS=""

  # Configure target opts
  PKG_CONFIGURE_OPTS_TARGET="--host=${TARGET_NAME} \
                             --disable-sdl \
                             --disable-vg \
                             --disable-oss \
                             --disable-al \
                             --disable-xvideo \
                             --disable-qt \
                             --disable-discord"

  # OpenGL support
  if [ "${OPENGL_SUPPORT}" = "yes" ]; then
    PKG_CONFIGURE_OPTS_TARGET+=" --enable-opengl \
                                 --enable-kms"
  else
    PKG_CONFIGURE_OPTS_TARGET+=" --disable-opengl1"
  fi

  # OpenGL ES support
  if [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_CONFIGURE_OPTS_TARGET+=" --enable-opengles"

    # RPi OpenGL ES 2.0 feature support
    if [ "${OPENGLES}" = "bcm2835-driver" ]; then
      PKG_CONFIGURE_OPTS_TARGET+=" --disable-opengl_core \
                                   --enable-dispmanx"

    # Mesa 3D OpenGL ES
    elif [ "${OPENGLES}" = "mesa" ]; then
      if [ "${DEVICE}" = "RPi4" -o "${DEVICE}" = "RPi3" ]; then
        PKG_CONFIGURE_OPTS_TARGET+=" --enable-opengles3 \
                                     --disable-videocore"
      fi

      # Panfrost: Mali T860 & G52 support OpenGLES 3.0
      if [ "${GRAPHIC_DRIVERS}" = "panfrost" ] && listcontains "${MALI_FAMILY}" "t860" || listcontains "${MALI_FAMILY}" "g52"; then
        PKG_CONFIGURE_OPTS_TARGET+=" --enable-opengles3"
      fi
    
    # Mali OpenGL ES 2.0/3.0 feature support
    elif [ "${OPENGLES}" = "libmali" ]; then
      if listcontains "${MALI_FAMILY}" "4[0-9]+"; then
        PKG_CONFIGURE_OPTS_TARGET+=" --disable-opengl_core \
                                     --disable-opengles3"
      else
        PKG_CONFIGURE_OPTS_TARGET+=" --enable-opengles3"
      fi
    fi
  fi

  # Displayserver support
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    PKG_CONFIGURE_OPTS_TARGET+=" --enable-x11"
  else
    PKG_CONFIGURE_OPTS_TARGET+=" --disable-x11"
  fi

  # Kernel Mode Setting (KMS) support
  if [ "${OPENGL}" = "mesa" ] || [ "${OPENGLES}" = "mesa" ] || [ "${OPENGLES}" = "libmali" ]; then
    PKG_CONFIGURE_OPTS_TARGET+=" --enable-kms"
  else
    PKG_CONFIGURE_OPTS_TARGET+=" --disable-kms"
  fi

  # Build EGL without X11 support
  if [ "${OPENGLES}" = "mesa" ] && [ ! "${DISPLAYSERVER}" = "x11" ]; then
    CFLAGS+=" -DEGL_NO_X11"
    CXXFLAGS+=" -DEGL_NO_X11"
  fi

  # ARM NEON Support
  if target_has_feature neon; then
    PKG_CONFIGURE_OPTS_TARGET+=" --enable-neon"
  fi

  # SSE Support
  if target_has_feature sse2; then
    PKG_CONFIGURE_OPTS_TARGET+=" --enable-sse"
  fi

  # Vulkan support
  if [ "${VULKAN_SUPPORT}" = "yes" ]; then
     PKG_CONFIGURE_OPTS_TARGET+=" --enable-vulkan"
  fi
}

make_target() {
  # Build Retroarch & exit if build fails
  echo -e "\n# Build Retroarch binary #\n"
  make GIT_VERSION=${PKG_VERSION:0:7}
  if [ ! -f ${PKG_BUILD}/retroarch ]; then
    exit 0
  fi

  # Build Video & DSP filter
  echo -e "\n# Build Video filter #\n"
  make -C gfx/video_filters compiler=${CC} extra_flags="${CFLAGS}"
  echo -e "\n# Build DSP filter #\n"
  make -C libretro-common/audio/dsp_filters compiler=${CC} extra_flags="${CFLAGS}"
}

makeinstall_target() {
  # Retroarch config file path
  PKG_RETROARCH_CONFIG_FILE_PATH="${INSTALL}/etc/retroarch.cfg"

  # Install Retroarch config
  mkdir -p ${INSTALL}/etc
    cp ${PKG_BUILD}/retroarch.cfg ${PKG_RETROARCH_CONFIG_FILE_PATH}

  # Install Video filter
  mkdir -p ${INSTALL}/usr/share/retroarch/filters/video
    cp ${PKG_BUILD}/gfx/video_filters/*.so   ${INSTALL}/usr/share/retroarch/filters/video
    cp ${PKG_BUILD}/gfx/video_filters/*.filt ${INSTALL}/usr/share/retroarch/filters/video

  # Install DSP filter
  mkdir -p ${INSTALL}/usr/share/retroarch/filters/audio
    cp ${PKG_BUILD}/libretro-common/audio/dsp_filters/*.so  ${INSTALL}/usr/share/retroarch/filters/audio
    cp ${PKG_BUILD}/libretro-common/audio/dsp_filters/*.dsp ${INSTALL}/usr/share/retroarch/filters/audio

  # Install binaries & scripts
  mkdir -p ${INSTALL}/usr/bin
    cp ${PKG_BUILD}/retroarch ${INSTALL}/usr/bin
  
  if [ "${DISPLAYSERVER}" = "x11" ]; then
    mkdir -p ${INSTALL}/usr/config/retroarch
      cp -PR ${PKG_DIR}/config/*  ${INSTALL}/usr/config/retroarch/
      cp -rf ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin/
  else
    cp -rf ${PKG_DIR}/scripts/frontend-retroarch.py ${INSTALL}/usr/bin/
    cp -rf ${PKG_DIR}/scripts/retroarch-nokms.start ${INSTALL}/usr/bin/retroarch.start
      sed -e "/# Change refresh.*/,+2d"          -i ${INSTALL}/usr/bin/*.start
  fi
  
  # General path configuration
  sed -e "s/# savefile_directory =/savefile_directory = \"\/storage\/.config\/retroarch\/saves\"/"                          -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# screenshot_directory =/screenshot_directory = \"\/storage\/screenshots\"/"                                    -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# recording_output_directory =/recording_output_directory = \"\/storage\/recordings\/retroarch\"/"              -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# recording_config_directory =/recording_config_directory = \"\/storage\/.config\/retroarch\/records_config\"/" -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# libretro_directory =/libretro_directory = \"\/tmp\/cores\"/"                                                  -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# libretro_info_path =/libretro_info_path = \"\/tmp\/coreinfo\"/"                                               -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# video_shader_dir =/video_shader_dir = \"\/tmp\/shaders\"/"                                                    -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# content_database_path =/content_database_path = \"\/tmp\/database\/rdb\"/"                                    -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# cheat_database_path =/cheat_database_path = \"\/tmp\/database\/cht\"/"                                        -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# cursor_directory =/cursor_directory = \"\/tmp\/database\/cursors\"/"                                          -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# assets_directory =/assets_directory = \"\/tmp\/assets\"/"                                                     -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# overlay_directory =/overlay_directory = \"\/tmp\/overlay\"/"                                                  -i ${PKG_RETROARCH_CONFIG_FILE_PATH}

  # General menu configuration
  sed -e "s/# rgui_browser_directory =/rgui_browser_directory = \"\/storage\/roms\"/" -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# system_directory =/system_directory = \"\/storage\/roms\/bios\"/"       -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# rgui_show_start_screen = true/rgui_show_start_screen = \"false\"/"      -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# menu_driver = \"rgui\"/menu_driver = \"xmb\"/"                          -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# video_shared_context = false/video_shared_context = \"true\"/"          -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# menu_show_core_updater = true/menu_show_core_updater = \"true\"/"       -i ${PKG_RETROARCH_CONFIG_FILE_PATH}

  # Video
  sed -e "s/# framecount_show =/framecount_show = \"false\"/"                                                     -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# video_fullscreen = false/video_fullscreen = \"true\"/"                                              -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# video_windowed_fullscreen = true/video_windowed_fullscreen = \"false\"/"                            -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# video_smooth = true/video_smooth = \"false\"/"                                                      -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# video_aspect_ratio_auto = false/video_aspect_ratio_auto = \"true\"/"                                -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# video_font_path =/video_font_path =\"\/usr\/share\/retroarch\/assets\/xmb\/monochrome\/font.ttf\"/" -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# video_font_enable = true/video_font_enable = \"true\"/"                                             -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# video_filter_dir =/video_filter_dir = \"\/usr\/share\/retroarch\/filters\/video\"/"                 -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# video_gpu_screenshot = true/video_gpu_screenshot = \"false\"/"                                      -i ${PKG_RETROARCH_CONFIG_FILE_PATH}

  # Audio
  sed -e "s/# audio_driver =/audio_driver = \"alsathread\"/"                                      -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# audio_filter_dir =/audio_filter_dir = \"\/usr\/share\/retroarch\/filters\/audio\"/" -i ${PKG_RETROARCH_CONFIG_FILE_PATH}

  # Workaround for Odroid XU3/XU4 55fps bug
  if [ "${DEVICE}" = "Exynos" ]; then 
    sed -e "s/# audio_out_rate = 48000/audio_out_rate = \"44100\"/" -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  fi

  # Input
  sed -e "s/# input_driver = sdl/input_driver = \"udev\"/"                                                            -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# input_max_users = 16/input_max_users = \"6\"/"                                                          -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# input_autodetect_enable = true/input_autodetect_enable = \"true\"/"                                     -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# joypad_autoconfig_dir =/joypad_autoconfig_dir = \"\/tmp\/autoconfig\"/"                                 -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# input_remapping_directory =/input_remapping_directory = \"\/storage\/.config\/retroarch\/remappings\"/" -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# input_menu_toggle_gamepad_combo = 0/input_menu_toggle_gamepad_combo = \"1\"/"                           -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# all_users_control_menu = false/all_users_control_menu = \"true\"/"                                      -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# input_exit_emulator = escape/input_exit_emulator = \"ralt\"/"                                           -i ${PKG_RETROARCH_CONFIG_FILE_PATH}

  # Menu
  sed -e "s/# menu_mouse_enable = false/menu_mouse_enable = \"false\"/"                                     -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# menu_core_enable = true/menu_core_enable = \"false\"/"                                        -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
  sed -e "s/# thumbnails_directory =/thumbnails_directory = \"\/storage\/.config\/retroarch\/thumbnails\"/" -i ${PKG_RETROARCH_CONFIG_FILE_PATH}

  # XMB Config
  echo "menu_show_advanced_settings = \"false\"" >> ${PKG_RETROARCH_CONFIG_FILE_PATH}
  echo "menu_wallpaper_opacity = \"1.0\""        >> ${PKG_RETROARCH_CONFIG_FILE_PATH}
  echo "content_show_images = \"false\""         >> ${PKG_RETROARCH_CONFIG_FILE_PATH}
  echo "content_show_music = \"false\""          >> ${PKG_RETROARCH_CONFIG_FILE_PATH}
  echo "content_show_video = \"false\""          >> ${PKG_RETROARCH_CONFIG_FILE_PATH}
  echo "xmb_menu_color_theme = \"8\""            >> ${PKG_RETROARCH_CONFIG_FILE_PATH}

  # Update URL to core update directory on buildbot
  if [ "${TARGET_ARCH}" = "arm" ]; then
    if target_has_feature neon; then
     sed -e "s/# core_updater_buildbot_url = \"http:\/\/buildbot.libretro.com\"/core_updater_buildbot_cores_url = \"http:\/\/buildbot.libretro.com\/nightly\/linux\/armv7-neon-hf\/latest\/\"/" -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
    else
     sed -e "s/# core_updater_buildbot_url = \"http:\/\/buildbot.libretro.com\"/core_updater_buildbot_cores_url = \"http:\/\/buildbot.libretro.com\/nightly\/linux\/armhf\/latest\/\"/"         -i ${PKG_RETROARCH_CONFIG_FILE_PATH}
    fi
  fi

  # Playlists
  echo "playlist_names = \"${RA_PLAYLIST_NAMES}\"" >> ${PKG_RETROARCH_CONFIG_FILE_PATH}
  echo "playlist_cores = \"${RA_PLAYLIST_CORES}\"" >> ${PKG_RETROARCH_CONFIG_FILE_PATH}
}

post_install() {  
  # Enable tmp asset directories
  enable_service tmp-assets.mount
  enable_service tmp-autoconfig.mount
  enable_service tmp-coreinfo.mount
  enable_service tmp-cores.mount
  enable_service tmp-database.mount
  enable_service tmp-overlay.mount
  enable_service tmp-shaders.mount
}
