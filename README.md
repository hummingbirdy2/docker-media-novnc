# docker-media-novnc

A VNC and noVNC docker with bunch of useful tool for video media based on [accetto/xubuntu-vnc-novnc:lab](https://github.com/accetto/xubuntu-vnc-novnc/tree/master/docker/xubuntu-vnc-novnc).

[![badge docker hub link][badge-docker-hub]](https://hub.docker.com/r/hummingbirdy2/media-novnc)
[![badge docker size][badge-docker-size]](https://hub.docker.com/r/hummingbirdy2/media-novnc)

[![badge github link][badge-github]](https://github.com/hummingbirdy2/docker-media-novnc)
[![badge licence][badge-license]](https://github.com/hummingbirdy2/docker-media-novnc)

## Embedded tools

- `vlc` : [VLC](https://www.videolan.org/vlc/).
  - `libdvd-pkg` : [DVD-Video playing library](https://packages.ubuntu.com/focal/libdvd-pkg).
  - `libbluray-bdj` : [Blu-ray Disc Java support library](https://packages.ubuntu.com/focal/libbluray-bdj).
- `mkvtoolnix-gui` : [mkvtoolnix](https://mkvtoolnix.download/).
- `mediainfo-gui` : [mediainfo](https://mediaarea.net/en/MediaInfo).
- `MakeMKV` : [MakeMKV](https://www.makemkv.com/).
- `VapourSynth + Editor` :
  - [VapourSynth](https://github.com/vapoursynth/vapoursynth).
  - [VapourSynth Editor](https://bitbucket.org/mystery_keeper/vapoursynth-editor).
- `audacity` : [Audacity](https://www.audacityteam.org/).
- `subtitleeditor` : [Subtitle Editor](https://github.com/kitone/subtitleeditor).
- `ffmpeg` : [ffmpeg](https://ffmpeg.org/).

## Limitations

- No audio are available :mute:
- `Subtitle Editor` can't open Blu-Ray Subttiltle file (`.sub`). And `Subtitle Edit` don't work smoothly on linux with wine (from my last test, if you know the good way to run, open a issues).
- Sadly, vlc can't open all Blu-Ray menu :disappointed_relieved:

## Usage

Start the container. The container will be deleted after the exit.
```shell
docker run -it --rm \
  --name=media-novnc \
  --user 1000:1000 \
  -e TZ=Europe/London \
  -e VNC_PW=<vnc password> `#optional` \
  -p 5901:5901 \
  -p 6901:6901 \
  -v <path to data>:/data \
  hummingbirdy2/media-novnc
```

## Parameters

| Parameter | Function |
| :----: | --- |
| `--user 1000:1000` | Change the default user. Only numerical UserID and GroupID are supported - see below for explanation (`1001:1001` by default) |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. [Time Zone list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) |
| `-e VNC_PW=<vnc password>` | Specify a vnc password (`headless` by default) |
| `-p 5901` | VNC TCP port |
| `-p 6901` | noVNC TCP port |
| `-v <path to data>` | Path to your data |

### User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```shell
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

## How To...

### ...Change Blu-Ray Region Code on VLC ?

To select the Blu-Ray Region Code, open **Tools** > **Preferences**

![Open VLC Preference](pictures/vlc_open_preference.jpg)

Show all settings, after **Input / Codecs** > **Access modules** > **Blu-ray** > **Region code** > **Save**

![Region code Selection](pictures/vlc_region_code_selection.jpg)

<!-- badges images -->
[badge-docker-hub]: https://badgen.net/badge/link/hummingbirdy2%2Fmedia-novnc?label&icon=docker
[badge-docker-size]: https://badgen.net/docker/size/hummingbirdy2/media-novnc?icon=docker&label=Image%20Size
[badge-github]: https://badgen.net/badge/link/hummingbirdy2%2Fdocker-media-novnc?label&icon=github
[badge-license]: https://badgen.net/github/license/hummingbirdy2/docker-media-novnc?icon=github
