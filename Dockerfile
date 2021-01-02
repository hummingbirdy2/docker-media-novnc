FROM accetto/xubuntu-vnc-novnc:lab

# ===========================
# Container labels
LABEL maintainer="Hummingbird the Second" \
      name="remux-box" \
      description="A noVNC docker with bunch of useful tool for video media."

# ===========================
# Switch to root user before install
USER 0

# ===========================
# Environment Settings
ENV DEBIAN_FRONTEND="noninteractive"

# Arguments Settings
ARG TZ=UTC

# ===========================
# Remove useless Desktop launchers

RUN echo -e '\n'"MISC: Remove useless desktop launchers" && \
  rm -v /home/headless/Desktop/versionsticker.desktop \
        /home/headless/Desktop/vim.desktop \
        /home/headless/Desktop/vncviewer.desktop

# ===========================
# Install mkvtoolnix
# mkvtoolnix: https://mkvtoolnix.download/downloads.html#ubuntu

RUN echo -e '\n'"MKVTOOLNIX: Install necessary packages" && \
  apt-get update && \
  apt-get install -y --no-install-recommends gnupg wget && \
  rm -rf /var/lib/apt/lists/* && \
  \
  echo -e '\n'"MKVTOOLNIX: Import the repository and the GPG key" && \
  wget -O- -q https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | apt-key add - && \
  echo "deb http://mkvtoolnix.download/ubuntu/ bionic main" > /etc/apt/sources.list.d/mkvtoolnix.list && \
  apt-get purge -y --auto-remove gnupg wget && \
  \
  echo -e '\n'"MKVTOOLNIX: Install" && \
  apt-get update && \
  apt-get install -y mkvtoolnix mkvtoolnix-gui && \
  rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/mkvtoolnix.list && \
  \
  echo -e '\n'"MKVTOOLNIX: Add Launcher on the desktop" && \
  cp -v /usr/share/applications/*mkvtoolnix-gui.desktop /home/headless/Desktop/mkvtoolnix-gui.desktop

# ===========================
# Install mediainfo
# dl: https://mediaarea.net/en/MediaInfo/Download/Debian
# wiki: https://mediaarea.net/en/Repos

RUN echo -e '\n'"MEDIAINFO: Install necessary packages" && \
  apt-get update && \
  apt-get install -y --no-install-recommends gnupg dirmngr && \
  rm -rf /var/lib/apt/lists/* && \
  \
  echo -e '\n'"MEDIAINFO: Import the repository’s GPG key" && \
  export GNUPGHOME="$(mktemp -d)" && \
  gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5CDF62C7AE05CC847657390C10E11090EC0E438 && \
  gpg --batch --export --armor C5CDF62C7AE05CC847657390C10E11090EC0E438 > /etc/apt/trusted.gpg.d/mediaarea.gpg.asc && \
  gpgconf --kill all && \
  rm -rf "$GNUPGHOME" && \
  apt-key list | grep 'MediaArea' && \
  apt-get purge -y --auto-remove gnupg dirmngr && \
  \
  echo -e '\n'"MEDIAINFO: Add the repository + install" && \
  echo "deb http://mediaarea.net/repo/deb/ubuntu bionic main" > /etc/apt/sources.list.d/mediaarea.list && \
  apt-get update && \
  apt-get install -y mediainfo-gui libmediainfo-dev && \
  rm -rf /var/lib/apt/lists/* /etc/apt/trusted.gpg.d/mediaarea.gpg.asc /etc/apt/sources.list.d/mediaarea.list && \
  \
  echo -e '\n'"MEDIAINFO: Add Launcher on the desktop" && \
  cp -v /usr/share/applications/*mediainfo-gui.desktop /home/headless/Desktop/mediainfo-gui.desktop

# ===========================
# Install VapourSynth
# git: https://github.com/vapoursynth/vapoursynth
# doc: http://www.vapoursynth.com/doc/installation.html#linux-and-os-x-compilation-instructions
# setup 101: https://www.l33tmeatwad.com/vapoursynth101/software-setup

ARG VAPOURSYNTH_VERSION=R52
ARG VAPOURSYNTH_SOURCE_URL=https://github.com/vapoursynth/vapoursynth/archive/${VAPOURSYNTH_VERSION}.tar.gz

ARG LSMASH_VERSION=2.14.5
ARG LSMASH_SOURCE_URL=https://github.com/l-smash/l-smash/archive/v${LSMASH_VERSION}.tar.gz

ARG ZIMG_VERSION=2.9.3
ARG ZIMG_SOURCE_URL=https://github.com/sekrit-twc/zimg/archive/release-${ZIMG_VERSION}.tar.gz

ARG IMAGEMAGICK_VERSION=7.0.10
ARG IMAGEMAGICK_RELEASE=48
ARG IMAGEMAGICK_SOURCE_URL=https://github.com/ImageMagick/ImageMagick/archive/${IMAGEMAGICK_VERSION}-${IMAGEMAGICK_RELEASE}.tar.gz

RUN echo -e '\n'"VAPOURSYNTH: Install necessary packages" && \
  apt-get update && \
  apt-get install -y --no-install-recommends curl tar \
    build-essential meson autoconf automake libtool nasm yasm \
    python3-dev python3-pip cython3 libass-dev qt5-default libqt5websockets5-dev \
    libfftw3-dev libtesseract-dev ffmpeg libavcodec-dev libavformat-dev libswscale-dev \
    libavutil-dev libswresample-dev libmediainfo-dev && \
  pip3 install --upgrade cython && \
  rm -rf /var/lib/apt/lists/* && \
  \
  echo -e '\n'"VAPOURSYNTH: Link default Python module" && \
  cd /usr/local/lib/python3.*/ && \
  ln -vs dist-packages site-packages && \
  ldconfig && \
  \
  echo -e '\n'"VAPOURSYNTH: Install of L-SMASH v$LSMASH_VERSION (additional dependency): Compilation from source" && \
  export SOURCE="$(mktemp -d)" && \
  curl -o "$SOURCE/tmp.tar.gz" -L $LSMASH_SOURCE_URL && \
  tar -xvf "$SOURCE/tmp.tar.gz" -C "$SOURCE" && \
  cd "$SOURCE/l-smash-${LSMASH_VERSION}" && \
  ./configure --enable-shared && \
  make lib && \
  make install-lib && \
  cd && \
  rm -rf "$SOURCE" && \
  \
  echo -e '\n'"VAPOURSYNTH: Install of Zing v$ZIMG_VERSION (additional dependency): Compilation from source" && \
  export SOURCE="$(mktemp -d)" && \
  curl -o "$SOURCE/tmp.tar.gz" -L $ZIMG_SOURCE_URL && \
  tar -xvf "$SOURCE/tmp.tar.gz" -C "$SOURCE" && \
  cd "$SOURCE/zimg-release-${ZIMG_VERSION}" && \
  ./autogen.sh && \
  ./configure && \
  make && \
  make install && \
  cd && \
  rm -rf "$SOURCE" && \
  \
  echo -e '\n'"VAPOURSYNTH: Install of ImageMagick v$IMAGEMAGICK_VERSION (additional dependency): Compilation from source" && \
  export SOURCE="$(mktemp -d)" && \
  curl -o "$SOURCE/tmp.tar.gz" -L $IMAGEMAGICK_SOURCE_URL && \
  tar -xvf "$SOURCE/tmp.tar.gz" -C "$SOURCE" && \
  cd "$SOURCE/ImageMagick-${IMAGEMAGICK_VERSION}-${IMAGEMAGICK_RELEASE}" && \
  ./configure && \
  make && \
  make install && \
  cd && \
  rm -rf "$SOURCE" && \
  \
  echo -e '\n'"VAPOURSYNTH: Compilation from source ($VAPOURSYNTH_VERSION)" && \
  export SOURCE="$(mktemp -d)" && \
  curl -o "$SOURCE/tmp.tar.gz" -L $VAPOURSYNTH_SOURCE_URL && \
  tar -xvf "$SOURCE/tmp.tar.gz" -C "$SOURCE" && \
  cd "$SOURCE/vapoursynth-${VAPOURSYNTH_VERSION}" && \
  ./autogen.sh && \
  ./configure && \
  make && \
  make install && \
  ldconfig && \
  cd && \
  rm -rf "$SOURCE"

# ===========================
# Install VapourSynth Editor
# git: https://bitbucket.org/mystery_keeper/vapoursynth-editor
# setup 101: https://www.l33tmeatwad.com/vapoursynth101/software-setup

ARG VSEDITOR_VERSION=r19
ARG VSEDITOR_SOURCE_URL=https://bitbucket.org/mystery_keeper/vapoursynth-editor/get/${VSEDITOR_VERSION}.tar.gz

COPY root/usr/share/applications/vsedit.desktop /usr/share/applications/vsedit.desktop

RUN echo -e '\n'"VS EDITOR: Compilation from source ($VSEDITOR_VERSION)" && \
  export SOURCE="$(mktemp -d)" && \
  curl -o "$SOURCE/tmp.tar.gz" -L $VSEDITOR_SOURCE_URL && \
  tar -xvf "$SOURCE/tmp.tar.gz" -C "$SOURCE" && \
  cd "$SOURCE/mystery_keeper-vapoursynth-editor-"*/pro && \
  qmake -norecursive pro.pro CONFIG+=release && \
  make && \
  mv ../build/release-64bit-gcc/vsedit /usr/local/bin/ && \
  mv ../build/release-64bit-gcc/vsedit-* /usr/local/bin/ && \
  mv ../build/release-64bit-gcc/vsedit.svg /usr/share/pixmaps/ && \
  cd && \
  rm -rf "$SOURCE" && \
  \
  echo -e '\n'"VS EDITOR: Add Launcher on the desktop" && \
  cp -v /usr/share/applications/*vsedit.desktop /home/headless/Desktop/vsedit.desktop

# ===========================
# Install vlc + lib for playback of Blu-Ray and DVD
# HTG: https://www.howtogeek.com/240487/how-to-play-dvds-and-blu-rays-on-linux/

COPY root/home/headless/.config/vlc /home/headless/.config/vlc

RUN echo -e '\n'"VLC: Install vlc + BD and DVD libs" && \
  apt-get update && \
  apt-get install -y vlc libdvd-pkg libbluray-bdj && \
  dpkg-reconfigure libdvd-pkg && \
  rm -rf /var/lib/apt/lists/* && \
  \
  echo -e '\n'"VLC: Add Launcher on the Desktop" && \
  cp -v /usr/share/applications/*vlc.desktop /home/headless/Desktop/vlc.desktop && \
  \
  echo -e '\n'"VLC: Set permission for parameters files" && \
  chmod -Rv 777 /home/headless/.config/vlc

# ===========================
# Install MakeMKV
# dl: https://www.makemkv.com/download/
# ppa-repository : https://launchpad.net/~heyarje/+archive/ubuntu/makemkv-beta

RUN echo -e '\n'"MAKEMKV: Install necessary packages" && \
  apt-get update && \
  apt-get install -y --no-install-recommends software-properties-common && \
  rm -rf /var/lib/apt/lists/* && \
  \
  echo -e '\n'"MAKEMKV: Install MakeMKV" && \
  add-apt-repository -y ppa:heyarje/makemkv-beta && \
  apt-get update && \
  apt-get install makemkv-bin makemkv-oss && \
  apt-get purge -y --auto-remove software-properties-common && \
  rm -rf /var/lib/apt/lists/* && \
  \
  echo -e '\n'"MAKEMKV: Add Direct Blu-ray playback with VLC (just in case)" && \
  ln -s /usr/lib/x86_64-linux-gnu/libmmbd.so.0 /usr/lib/. && \
  \
  echo -e '\n'"MAKEMKV: Add Launcher on the Desktop" && \
  cp -v /usr/share/applications/*makemkv.desktop /home/headless/Desktop/makemkv.desktop

# ===========================
# Install others tools
# audacity: https://www.audacityteam.org/

RUN echo -e '\n'"OTHERS: Install others tools" && \
  apt-get update && \
  apt-get install -y audacity subtitleeditor && \
  rm -rf /var/lib/apt/lists/* && \
  \
  echo -e '\n'"OTHERS: Add Launchers on the Desktop" && \
  cp -v /usr/share/applications/*audacity.desktop /home/headless/Desktop/audacity.desktop && \
  cp -v /usr/share/applications/*subtitleeditor.desktop /home/headless/Desktop/subtitleeditor.desktop

# ===========================
# Set permission for desktop launchers

RUN echo -e '\n'"MISC: Set permission for desktop launchers" && \
  chmod -v 777 /home/headless/Desktop/*.desktop

# ===========================
# Switch back to default application user (non-root)
USER 1001

# volumes
VOLUME /config
