FROM ubuntu:16.04

MAINTAINER juaxix <jbelon@cvc.uab.es>

#Add display driver
#ADD NVIDIA-Linux-x86_64-340.76.run /tmp/NVIDIA-DRIVER.run
RUN apt-get update 
RUN apt-get -yq install mono-complete build-essential \
  mono-reference-assemblies-4.0 mono-devel mono-xbuild mono-mcs mono-devel \
  cmake dos2unix clang-3.5 libfreetype6-dev \
  libgtk-3-dev xdg-user-dirs pulseaudio alsa-utils \
  x11-apps libclang-common-3.5-dev libclang1-3.5 libllvm3.5v5 llvm-3.5 \
  llvm-3.5-dev llvm-3.5-runtime libgtk-3-0 git codelite wxcrafter

Add UnrealEngine ~/UnrealEngine_4.18

#Add user `unreal`
RUN useradd -ms /bin/bash unreal
RUN adduser unreal sudo
RUN git clone --depth=1 -b 4.18 https://github.com/EpicGames/UnrealEngine.git ~/UnrealEngine_4.18
#RUN ./Setup.sh --> this is run on the host to safe time on the docker build and rebuild in case you need to add dependecies
WORKDIR /UnrealEngine_4.18
CMD ~/UnrealEngine_4.18
RUN ~/UnrealEngine_4.18/Setup.sh
RUN ~/UnrealEngine_4.18/GenerateProjectFiles.sh

#change the directory to the unreal user
RUN chown -R unreal:unreal ~/UnrealEngine_4.18
