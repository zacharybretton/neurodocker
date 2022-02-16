# Generated by: Neurodocker version 0.7.0
# Latest release: Neurodocker version 0.7.0
# Timestamp: 2022/02/16 17:10:09 UTC
# 
# Thank you for using Neurodocker. If you discover any issues
# or ways to improve this software, please submit an issue or
# pull request on our GitHub repository:
# 
#     https://github.com/ReproNim/neurodocker

FROM ubuntu:20.04

USER root

ARG DEBIAN_FRONTEND="noninteractive"

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    ND_ENTRYPOINT="/neurodocker/startup.sh"
RUN export ND_ENTRYPOINT="/neurodocker/startup.sh" \
    && apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           apt-utils \
           bzip2 \
           ca-certificates \
           curl \
           locales \
           unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG="en_US.UTF-8" \
    && chmod 777 /opt && chmod a+s /opt \
    && mkdir -p /neurodocker \
    && if [ ! -f "$ND_ENTRYPOINT" ]; then \
         echo '#!/usr/bin/env bash' >> "$ND_ENTRYPOINT" \
    &&   echo 'set -e' >> "$ND_ENTRYPOINT" \
    &&   echo 'export USER="${USER:=`whoami`}"' >> "$ND_ENTRYPOINT" \
    &&   echo 'if [ -n "$1" ]; then "$@"; else /usr/bin/env bash; fi' >> "$ND_ENTRYPOINT"; \
    fi \
    && chmod -R 777 /neurodocker && chmod a+s /neurodocker

ENTRYPOINT ["/neurodocker/startup.sh"]

RUN bash -c 'add-apt-repository universe'

RUN bash -c 'add-apt-repository -y ppa:marutter/rrutter4.0'

RUN bash -c 'add-apt-repository -y ppa:c2d4u.team/c2d4u4.0+'

RUN bash -c 'apt-get update'

RUN apt-get update -qq \
    && apt-get install -y --quiet \
           vim \
           libopenmpi-dev \
           libcurl4-openssl-dev \
           libxml2-dev \
           libssl-dev \
           libudunits2-dev \
           libv8-dev \
           cmake \
           libncurses5 \
           libgsl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update -qq \
    && apt-get install -y --quiet \
           tcsh \
           xfonts-base \
           libssl-dev \
           python-is-python3 \
           python3-matplotlib \
           python3-numpy \
           gsl-bin \
           netpbm \
           gnome-tweak-tool \
           libjpeg62 \
           xvfb \
           xterm \
           vim \
           curl \
           gedit \
           evince \
           eog \
           libglu1-mesa-dev \
           libglw1-mesa \
           libxm4 \
           build-essential \
           libcurl4-openssl-dev \
           libxml2-dev \
           libgfortran-8-dev \
           libgomp1 \
           gnome-terminal \
           nautilus \
           gnome-icon-theme-symbolic \
           firefox \
           xfonts-100dpi \
           r-base-dev \
           libgdal-dev \
           libopenblas-dev \
           libnode-dev \
           libudunits2-dev \
           libgfortran4 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/opt/afni-latest:$PATH" \
    AFNI_PLUGINPATH="/opt/afni-latest"
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           ed \
           gsl-bin \
           libglib2.0-0 \
           libglu1-mesa-dev \
           libglw1-mesa \
           libgomp1 \
           libjpeg62 \
           libxm4 \
           netpbm \
           tcsh \
           xfonts-base \
           xvfb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sSL --retry 5 -o /tmp/toinstall.deb http://mirrors.kernel.org/debian/pool/main/libx/libxp/libxp6_1.0.2-2_amd64.deb \
    && dpkg -i /tmp/toinstall.deb \
    && rm /tmp/toinstall.deb \
    && curl -sSL --retry 5 -o /tmp/toinstall.deb http://snapshot.debian.org/archive/debian-security/20160113T213056Z/pool/updates/main/libp/libpng/libpng12-0_1.2.49-1%2Bdeb7u2_amd64.deb \
    && dpkg -i /tmp/toinstall.deb \
    && rm /tmp/toinstall.deb \
    && apt-get install -f \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && gsl2_path="$(find / -name 'libgsl.so.19' || printf '')" \
    && if [ -n "$gsl2_path" ]; then \
         ln -sfv "$gsl2_path" "$(dirname $gsl2_path)/libgsl.so.0"; \
    fi \
    && ldconfig \
    && echo "Downloading AFNI ..." \
    && mkdir -p /opt/afni-latest \
    && curl -fsSL --retry 5 https://afni.nimh.nih.gov/pub/dist/tgz/linux_openmp_64.tgz \
    | tar -xz -C /opt/afni-latest --strip-components 1

RUN bash -c 'apt -y upgrade'

RUN test "$(getent passwd neuro)" || useradd --no-user-group --create-home --shell /bin/bash neuro
USER neuro

RUN echo '{ \
    \n  "pkg_manager": "apt", \
    \n  "instructions": [ \
    \n    [ \
    \n      "base", \
    \n      "ubuntu:20.04" \
    \n    ], \
    \n    [ \
    \n      "run_bash", \
    \n      "add-apt-repository universe" \
    \n    ], \
    \n    [ \
    \n      "run_bash", \
    \n      "add-apt-repository -y ppa:marutter/rrutter4.0" \
    \n    ], \
    \n    [ \
    \n      "run_bash", \
    \n      "add-apt-repository -y ppa:c2d4u.team/c2d4u4.0+" \
    \n    ], \
    \n    [ \
    \n      "run_bash", \
    \n      "apt-get update" \
    \n    ], \
    \n    [ \
    \n      "install", \
    \n      [ \
    \n        "apt_opts=--quiet", \
    \n        "vim", \
    \n        "libopenmpi-dev", \
    \n        "libcurl4-openssl-dev", \
    \n        "libxml2-dev", \
    \n        "libssl-dev", \
    \n        "libudunits2-dev", \
    \n        "libv8-dev", \
    \n        "cmake", \
    \n        "libncurses5", \
    \n        "libgsl-dev" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "install", \
    \n      [ \
    \n        "apt_opts=--quiet", \
    \n        "tcsh", \
    \n        "xfonts-base", \
    \n        "libssl-dev", \
    \n        "python-is-python3", \
    \n        "python3-matplotlib", \
    \n        "python3-numpy", \
    \n        "gsl-bin", \
    \n        "netpbm", \
    \n        "gnome-tweak-tool", \
    \n        "libjpeg62", \
    \n        "xvfb", \
    \n        "xterm", \
    \n        "vim", \
    \n        "curl", \
    \n        "gedit", \
    \n        "evince", \
    \n        "eog", \
    \n        "libglu1-mesa-dev", \
    \n        "libglw1-mesa", \
    \n        "libxm4", \
    \n        "build-essential", \
    \n        "libcurl4-openssl-dev", \
    \n        "libxml2-dev", \
    \n        "libgfortran-8-dev", \
    \n        "libgomp1", \
    \n        "gnome-terminal", \
    \n        "nautilus", \
    \n        "gnome-icon-theme-symbolic", \
    \n        "firefox", \
    \n        "xfonts-100dpi", \
    \n        "r-base-dev", \
    \n        "libgdal-dev", \
    \n        "libopenblas-dev", \
    \n        "libnode-dev", \
    \n        "libudunits2-dev", \
    \n        "libgfortran4" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "afni", \
    \n      { \
    \n        "version": "latest", \
    \n        "method": "binaries" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "run_bash", \
    \n      "apt -y upgrade" \
    \n    ], \
    \n    [ \
    \n      "user", \
    \n      "neuro" \
    \n    ] \
    \n  ] \
    \n}' > /neurodocker/neurodocker_specs.json
