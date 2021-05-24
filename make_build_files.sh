#!/bin/bash
generate_docker() {
  sudo docker run repronim/neurodocker:master generate docker \
    --base=neurodebian:nd16.04 --pkg-manager=apt \
    --user=neuro \
    --install apt_opts="--quiet" vim libopenmpi-dev \
    --afni version=latest method=binaries install_r=true install_r_pkgs=true \
    --fsl version=6.0.4 method=binaries \
    --ants version=2.3.1 method=binaries \
    --dcm2niix version=2bf2e482aec8e9959c6bd8e833cdccba3607c617 method=source \
    --convert3d version=1.0.0 method=binaries \
    --freesurfer version=7.1.1 method=binaries \
    --copy license.txt /home/neuro/license.txt \
    --env FS_LICENSE=/home/neuro/license.txt \
    --matlabmcr version=2018a method=binaries \
    --miniconda \
          use_env=base \
          conda_install='python=3.8 matplotlib numpy pandas scikit-learn nilearn scipy seaborn traits' \
          pip_install='nipype pingouin brainiak ipython'
    #--add-to-entrypoint "source /opt/freesurfer-7.1.1/SetUpFreeSurfer.sh"
}
generate_docker_r() {
  sudo docker run repronim/neurodocker:master generate docker \
    --base=neurodebian:nd16.04 --pkg-manager=apt \
    --install apt_opts="--quiet" vim libopenmpi-dev \
    --afni version=latest install_r=true install_r_pkgs=true method=binaries
}
# generate_singularity () {
#  sudo docker run repronim/neurodocker:master generate singularity \
# }
generate_docker > Dockerfile
generate_docker_r > Dockerfile_R
# generate_singularity > Singularity