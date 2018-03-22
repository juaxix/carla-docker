FROM ubuntu:latest

MAINTAINER Juan Belón <jbelon@cvc.uab.es>

#Configure system
RUN apt-get update 
RUN apt-get install -y --no-install-recommends apt-utils dialog
RUN apt-get install -y git sudo tzdata && rm -rf /var/lib/apt/lists/*
RUN apt-get install -y build-essential clang-3.9 git cmake ninja-build python3-pip python3-requests python-dev tzdata sed curl wget unzip autoconf libtool
RUN pip3 install protobuf
RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/lib/llvm-3.9/bin/clang++ 100
RUN update-alternatives --install /usr/bin/clang clang /usr/lib/llvm-3.9/bin/clang 100

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
