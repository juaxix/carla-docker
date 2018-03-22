FROM ubuntu:16.04

MAINTAINER Juan Belón <jbelon@cvc.uab.es>

#Configure system
ENV DEBIAN_FRONTEND=noninteractive 
RUN apt-get update -y && \
  apt-get install -y --no-install-recommends apt-utils dialog \
  git sudo tzdata build-essential clang-3.9 git cmake ninja-build \
  python3-pip python3-requests python-dev sed curl wget unzip autoconf libtool && \
  pip3 install protobuf && \
  update-alternatives --install /usr/bin/clang++ clang++ /usr/lib/llvm-3.9/bin/clang++ 100 && \
  update-alternatives --install /usr/bin/clang clang /usr/lib/llvm-3.9/bin/clang 100

#Download and compile Unreal Engine 4.18
CMD git clone --depth=1 -b 4.18 https://github.com/EpicGames/UnrealEngine.git ~/UnrealEngine_4.18 && \
	cd ~/UnrealEngine_4.18 && \
	./Setup.sh && \
	./GenerateProjectFiles.sh && \
	make && \
	chmod 0777 ../  # Allows the users on the outside to delete the folder
	
#Export Unreal Location to a var
CMD UE4_ROOT=~/UnrealEngine_4.18 ./Rebuild.sh
CMD export UE4_ROOT=~/UnrealEngine_4.18 ./Rebuild.sh

CMD git clone https://github.com/carla-simulator/carla ~/CARLA && \
	cd ~/CARLA && \
	./Setup.sh
