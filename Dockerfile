FROM accetto/xubuntu-vnc-novnc:lab

# ===========================
# Switch to root user before install
USER 0

# ===========================
# Environment Settings
ENV DEBIAN_FRONTEND="noninteractive"

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
  rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/mkvtoolnix.list

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
  apt-get install -y mediainfo-gui && \
  rm -rf /var/lib/apt/lists/* /etc/apt/trusted.gpg.d/mediaarea.gpg.asc /etc/apt/sources.list.d/mediaarea.list

# ===========================
# Install vlc + lib for playback of Blu-Ray and DVD
# HTG: https://www.howtogeek.com/240487/how-to-play-dvds-and-blu-rays-on-linux/

RUN echo -e '\n'"VLC: Install vlc + BD and DVD libs" && \
  apt-get update && \
  apt-get install -y vlc libdvd-pkg libbluray-bdj && \
  dpkg-reconfigure libdvd-pkg &&\
  rm -rf /var/lib/apt/lists/*

# ===========================
# Install others tools
# audacity: https://www.audacityteam.org/

RUN echo -e '\n'"OTHERS: Install others tools" && \
  apt-get update && \
  apt-get install -y audacity ffmpeg subtitleeditor && \
  rm -rf /var/lib/apt/lists/*

# ===========================
# Switch back to default application user (non-root)
USER 1001

# volumes
VOLUME /config
