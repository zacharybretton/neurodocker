# Generated by: Neurodocker version 0.7.0+25.gf104933.dirty
# Latest release: Neurodocker version 0.7.0
# 
# Thank you for using Neurodocker. If you discover any issues
# or ways to improve this software, please submit an issue or
# pull request on our GitHub repository:
# 
#     https://github.com/ReproNim/neurodocker
# 
# Timestamp: 2021/05/22 21:59:19 UTC

FROM ubuntu:18.04

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

RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           vim \
           libopenmpi-dev \
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
           libnlopt-dev \
           libxm4 \
           multiarch-support \
           netpbm \
           r-base \
           r-base-dev \
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
    | tar -xz -C /opt/afni-latest --strip-components 1 \
    && PATH=$PATH:/opt/afni-latest rPkgsInstall -pkgs ALL

ENV FSLDIR="/opt/fsl-6.0.4" \
    PATH="/opt/fsl-6.0.4/bin:$PATH" \
    FSLOUTPUTTYPE="NIFTI_GZ" \
    FSLMULTIFILEQUIT="TRUE" \
    FSLTCLSH="/opt/fsl-6.0.4/bin/fsltclsh" \
    FSLWISH="/opt/fsl-6.0.4/bin/fslwish" \
    FSLLOCKDIR="" \
    FSLMACHINELIST="" \
    FSLREMOTECALL="" \
    FSLGECUDAQ="cuda.q"
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           bc \
           dc \
           file \
           libfontconfig1 \
           libfreetype6 \
           libgl1-mesa-dev \
           libgl1-mesa-dri \
           libglu1-mesa-dev \
           libgomp1 \
           libice6 \
           libxcursor1 \
           libxft2 \
           libxinerama1 \
           libxrandr2 \
           libxrender1 \
           libxt6 \
           sudo \
           wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Downloading FSL ..." \
    && mkdir -p /opt/fsl-6.0.4 \
    && curl -fsSL --retry 5 https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-6.0.4-centos6_64.tar.gz \
    | tar -xz -C /opt/fsl-6.0.4 --strip-components 1 \
    && sed -i '$iecho Some packages in this Docker container are non-free' $ND_ENTRYPOINT \
    && sed -i '$iecho If you are considering commercial use of this container, please consult the relevant license:' $ND_ENTRYPOINT \
    && sed -i '$iecho https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Licence' $ND_ENTRYPOINT \
    && sed -i '$isource $FSLDIR/etc/fslconf/fsl.sh' $ND_ENTRYPOINT

ENV ANTSPATH="/opt/ants-2.3.1" \
    PATH="/opt/ants-2.3.1:$PATH"
RUN echo "Downloading ANTs ..." \
    && mkdir -p /opt/ants-2.3.1 \
    && curl -fsSL --retry 5 https://dl.dropbox.com/s/1xfhydsf4t4qoxg/ants-Linux-centos6_x86_64-v2.3.1.tar.gz \
    | tar -xz -C /opt/ants-2.3.1 --strip-components 1

ENV PATH="/opt/dcm2niix-2bf2e482aec8e9959c6bd8e833cdccba3607c617/bin:$PATH"
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           cmake \
           g++ \
           gcc \
           git \
           make \
           pigz \
           zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/rordenlab/dcm2niix /tmp/dcm2niix \
    && cd /tmp/dcm2niix \
    && git fetch --tags \
    && git checkout 2bf2e482aec8e9959c6bd8e833cdccba3607c617 \
    && mkdir /tmp/dcm2niix/build \
    && cd /tmp/dcm2niix/build \
    && cmake  -DCMAKE_INSTALL_PREFIX:PATH=/opt/dcm2niix-2bf2e482aec8e9959c6bd8e833cdccba3607c617 .. \
    && make \
    && make install \
    && rm -rf /tmp/dcm2niix

ENV C3DPATH="/opt/convert3d-1.0.0" \
    PATH="/opt/convert3d-1.0.0/bin:$PATH"
RUN echo "Downloading Convert3D ..." \
    && mkdir -p /opt/convert3d-1.0.0 \
    && curl -fsSL --retry 5 https://sourceforge.net/projects/c3d/files/c3d/1.0.0/c3d-1.0.0-Linux-x86_64.tar.gz/download \
    | tar -xz -C /opt/convert3d-1.0.0 --strip-components 1

ENV FREESURFER_HOME="/opt/freesurfer-7.1.1" \
    PATH="/opt/freesurfer-7.1.1/bin:$PATH"
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           bc \
           libgomp1 \
           libxmu6 \
           libxt6 \
           perl \
           tcsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Downloading FreeSurfer ..." \
    && mkdir -p /opt/freesurfer-7.1.1 \
    && curl -fsSL --retry 5 https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.1.1/freesurfer-linux-centos6_x86_64-7.1.1.tar.gz \
    | tar -xz -C /opt/freesurfer-7.1.1 --strip-components 1 \
         --exclude='freesurfer/average/mult-comp-cor' \
         --exclude='freesurfer/lib/cuda' \
         --exclude='freesurfer/lib/qt' \
         --exclude='freesurfer/subjects/V1_average' \
         --exclude='freesurfer/subjects/bert' \
         --exclude='freesurfer/subjects/cvs_avg35' \
         --exclude='freesurfer/subjects/cvs_avg35_inMNI152' \
         --exclude='freesurfer/subjects/fsaverage3' \
         --exclude='freesurfer/subjects/fsaverage4' \
         --exclude='freesurfer/subjects/fsaverage5' \
         --exclude='freesurfer/subjects/fsaverage6' \
         --exclude='freesurfer/subjects/fsaverage_sym' \
         --exclude='freesurfer/trctrain' \
    && sed -i '$isource "/opt/freesurfer-7.1.1/SetUpFreeSurfer.sh"' "$ND_ENTRYPOINT"

COPY ["license.txt", "/home/neuro/license.txt"]

ENV FS_LICENSE="/home/neuro/license.txt"

ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu:/opt/matlabmcr-2018a/v94/runtime/glnxa64:/opt/matlabmcr-2018a/v94/bin/glnxa64:/opt/matlabmcr-2018a/v94/sys/os/glnxa64:/opt/matlabmcr-2018a/v94/extern/bin/glnxa64" \
    MATLABCMD="/opt/matlabmcr-2018a/v94/toolbox/matlab"
RUN export TMPDIR="$(mktemp -d)" \
    && apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           bc \
           libncurses5 \
           libxext6 \
           libxmu6 \
           libxpm-dev \
           libxt6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Downloading MATLAB Compiler Runtime ..." \
    && curl -fsSL --retry 5 -o "$TMPDIR/mcr.zip" https://ssd.mathworks.com/supportfiles/downloads/R2018a/deployment_files/R2018a/installers/glnxa64/MCR_R2018a_glnxa64_installer.zip \
    && unzip -q "$TMPDIR/mcr.zip" -d "$TMPDIR/mcrtmp" \
    && "$TMPDIR/mcrtmp/install" -destinationFolder /opt/matlabmcr-2018a -mode silent -agreeToLicense yes \
    && rm -rf "$TMPDIR" \
    && unset TMPDIR

RUN test "$(getent passwd neuro)" || useradd --no-user-group --create-home --shell /bin/bash neuro
USER neuro

ENV CONDA_DIR="/opt/miniconda-latest" \
    PATH="/opt/miniconda-latest/bin:$PATH"
RUN export PATH="/opt/miniconda-latest/bin:$PATH" \
    && echo "Downloading Miniconda installer ..." \
    && conda_installer="/tmp/miniconda.sh" \
    && curl -fsSL --retry 5 -o "$conda_installer" https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash "$conda_installer" -b -p /opt/miniconda-latest \
    && rm -f "$conda_installer" \
    && conda update -yq -nbase conda \
    && conda config --system --prepend channels conda-forge \
    && conda config --system --set auto_update_conda false \
    && conda config --system --set show_channel_urls true \
    && sync && conda clean -y --all && sync \
    && conda create -y -q --name neuro \
    && conda install -y -q --name neuro \
           "python=3.8" \
           "matplotlib" \
           "numpy" \
           "pandas" \
           "scikit-learn" \
           "nilearn" \
           "scipy" \
           "seaborn" \
           "traits" \
    && sync && conda clean -y --all && sync \
    && bash -c "source activate neuro \
    &&   pip install --no-cache-dir  \
             "nipype" \
             "pingouin" \
             "brainiak" \
             "ipython"" \
    && rm -rf ~/.cache/pip/* \
    && sync \
    && sed -i '$isource activate neuro' $ND_ENTRYPOINT

RUN sed -i '$isource /opt/freesurfer-7.1.1/SetUpFreeSurfer.sh' $ND_ENTRYPOINT

RUN echo '{ \
    \n  "pkg_manager": "apt", \
    \n  "instructions": [ \
    \n    [ \
    \n      "base", \
    \n      "ubuntu:18.04" \
    \n    ], \
    \n    [ \
    \n      "install", \
    \n      [ \
    \n        "vim", \
    \n        "libopenmpi-dev" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "afni", \
    \n      { \
    \n        "version": "latest", \
    \n        "install_r": "TRUE", \
    \n        "install_r_pkgs": "TRUE", \
    \n        "method": "binaries" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "fsl", \
    \n      { \
    \n        "version": "6.0.4", \
    \n        "method": "binaries" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "ants", \
    \n      { \
    \n        "version": "2.3.1", \
    \n        "method": "binaries" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "dcm2niix", \
    \n      { \
    \n        "version": "2bf2e482aec8e9959c6bd8e833cdccba3607c617", \
    \n        "method": "source" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "convert3d", \
    \n      { \
    \n        "version": "1.0.0", \
    \n        "method": "binaries" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "freesurfer", \
    \n      { \
    \n        "version": "7.1.1", \
    \n        "method": "binaries" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "copy", \
    \n      [ \
    \n        "license.txt", \
    \n        "/home/neuro/license.txt" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "env", \
    \n      { \
    \n        "FS_LICENSE": "/home/neuro/license.txt" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "matlabmcr", \
    \n      { \
    \n        "version": "2018a", \
    \n        "method": "binaries" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "user", \
    \n      "neuro" \
    \n    ], \
    \n    [ \
    \n      "miniconda", \
    \n      { \
    \n        "create_env": "neuro", \
    \n        "activate": true, \
    \n        "conda_install": [ \
    \n          "python=3.8", \
    \n          "matplotlib", \
    \n          "numpy", \
    \n          "pandas", \
    \n          "scikit-learn", \
    \n          "nilearn", \
    \n          "scipy", \
    \n          "seaborn", \
    \n          "traits" \
    \n        ], \
    \n        "pip_install": [ \
    \n          "nipype", \
    \n          "pingouin", \
    \n          "brainiak", \
    \n          "ipython" \
    \n        ] \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "add_to_entrypoint", \
    \n      "source /opt/freesurfer-7.1.1/SetUpFreeSurfer.sh" \
    \n    ] \
    \n  ] \
    \n}' > /neurodocker/neurodocker_specs.json
