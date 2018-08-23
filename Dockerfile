FROM alpine

RUN apk add --no-cache automake bash bison file flex curl g++ gawk gcc gperf help2man \
	linux-headers make musl-dev ncurses-dev parallel patch python3 rsync sed tar texinfo wget xz
RUN curl http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.23.0.tar.xz | tar xJ && \
	cd crosstool-ng-1.23.0 && \
	./configure --prefix=/usr/local && \
	make -j && \
	make install && \
	cd .. && \
	rm -r crosstool-ng-1.23.0
RUN addgroup build && \
	adduser -D build -G build -h /home/build

USER build
WORKDIR /home/build
RUN mkdir -p config src

WORKDIR /home/build/config

COPY --chown=build:build aarch64-unknown-eabi defconfig
RUN ct-ng defconfig

# TODO: this triple is actually broken on the latest release...
COPY --chown=build:build aarch64-unknown-linux-gnueabi defconfig
RUN ct-ng defconfig
# RUN ct-ng build

COPY --chown=build:build aarch64-unknown-linux-uclibcgnueabi defconfig
RUN ct-ng defconfig
RUN ct-ng build

# arm-unknown-eabi
COPY --chown=build:build arm-unknown-eabi defconfig
RUN ct-ng defconfig
RUN ct-ng build

# arm-unknown-linux-gnueabi
COPY --chown=build:build arm-unknown-linux-gnueabi defconfig
RUN ct-ng defconfig
# RUN ct-ng build

# arm-unknown-linux-musleabi
COPY --chown=build:build arm-unknown-linux-musleabi defconfig
RUN ct-ng defconfig
RUN ct-ng build

# arm-unknown-linux-uclibcgnueabi
COPY --chown=build:build arm-unknown-linux-uclibcgnueabi defconfig
RUN ct-ng defconfig
RUN ct-ng build

# i686-unknown-none
COPY --chown=build:build i686-unknown-elf defconfig
RUN ct-ng defconfig
RUN ct-ng build

# i686-unknown-linux-gnu
COPY --chown=build:build i686-unknown-linux-gnu defconfig
RUN ct-ng defconfig
# RUN ct-ng build

# i686-unknown-linux-musl
COPY --chown=build:build i686-unknown-linux-musl defconfig
RUN ct-ng defconfig
RUN ct-ng build

# i686-unknown-linux-uclibc
# COPY --chown=build:build i686-unknown-linux-uclibc defconfig
# RUN ct-ng defconfig
# RUN ct-ng build

# i686-w64-mingw32
# powerpc-none
# powerpc-powerpc-unknown-linux-gnu
# powerpc-powerpc-unknown-linux-musl
# powerpc-powerpc-unknown-linux-uclibc
# x86_64-pc-none
# x86_64-pc-linux-gnu
# x86_64-pc-linux-musl
# x86_64-pc-linux-uclibc
# x86_64-pc-mingw32

RUN rsync -Pa /home/build/x-tools/aarch64-unknown-linux-uclibcgnueabi/ /home/build/x/
RUN rsync -Pa /home/build/x-tools/arm-unknown-eabi/ /home/build/x/
RUN rsync -Pa /home/build/x-tools/arm-unknown-linux-musleabi/ /home/build/x/
RUN rsync -Pa /home/build/x-tools/arm-unknown-linux-uclibcgnueabi/ /home/build/x/
RUN rsync -Pa /home/build/x-tools/i686-unknown-elf/ /home/build/x/
RUN rsync -Pa /home/build/x-tools/i686-unknown-linux-musl/ /home/build/x/
ENV PATH=/home/build/x/bin:$PATH
