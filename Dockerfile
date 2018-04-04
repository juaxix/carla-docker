ARG git_username
ARG git_token
FROM ubuntu:16.04

# packaging dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        dh-make \
        fakeroot \
        build-essential \
        devscripts \
        lsb-release && \
    rm -rf /var/lib/apt/lists/*
# packaging
ARG PKG_VERS
ARG PKG_REV
ARG RUNTIME_VERSION
ARG DOCKER_VERSION

ENV DEBFULLNAME "NVIDIA CORPORATION"
ENV DEBEMAIL "cudatools@nvidia.com"
ENV REVISION "$PKG_VERS-$PKG_REV"
ENV RUNTIME_VERSION $RUNTIME_VERSION
ENV DOCKER_VERSION $DOCKER_VERSION
ENV SECTION ""

# output directory
ENV DIST_DIR=/tmp/nvidia-docker2-$PKG_VERS
RUN mkdir -p $DIST_DIR

# nvidia-docker 2.0
COPY nvidia-docker $DIST_DIR/nvidia-docker
COPY daemon.json $DIST_DIR/daemon.json

WORKDIR $DIST_DIR
COPY debian ./debian

RUN sed -i "s;@VERSION@;${REVISION#*+};" debian/changelog && \
    if [ "$REVISION" != "$(dpkg-parsechangelog --show-field=Version)" ]; then exit 1; fi

CMD export DISTRIB="$(lsb_release -cs)" && \
    debuild --preserve-env --dpkg-buildpackage-hook='sh debian/prepare' -i -us -uc -b && \
mv /tmp/*.deb /dist

# UNREAL PART
RUN apt-get -yq install mono-complete build-essential \
  mono-reference-assemblies-4.0 mono-devel mono-xbuild mono-mcs mono-devel \
  cmake dos2unix clang-3.5 libfreetype6-dev \
  libgtk-3-dev xdg-user-dirs pulseaudio alsa-utils \
  x11-apps libclang-common-3.5-dev libclang1-3.5 libllvm3.5v5 llvm-3.5 \
  llvm-3.5-dev llvm-3.5-runtime libgtk-3-0 git 
 
CMD mkdir $DIST_DIR/UnrealEngine_4.18
CMD git clone --depth=1 -b 4.18 https://${git_username}:${git_token}@github.com/EpicGames/UnrealEngine.git $DIST_DIR/UnrealEngine_4.18
CMD $DIST_DIR/UnrealEngine_4.18/Setup.sh
CMD $DIST_DIR/UnrealEngine_4.18/GenerateProjectFiles.sh
