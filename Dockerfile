FROM gentoo/stage3-amd64-nomultilib

# Dependencies
RUN emerge --sync
COPY package.keywords /etc/portage/package.keywords/megacrossbuild
COPY package.use /etc/portage/package.use/megacrossbuild
RUN emerge dev-util/ninja sys-devel/crossdev sys-devel/ct-ng
RUN mkdir -p /usr/local/portage-crossdev/{metadata,profiles}
RUN echo crossdev > /usr/local/portage-crossdev/profiles/repo_name
RUN echo masters = gentoo > /usr/local/portage-crossdev/metadata/layout.conf
RUN chown -R portage:portage /usr/local/portage-crossdev
COPY crossdev.conf /etc/portage/repos.conf/crossdev.conf

# Linux+glibc
RUN crossdev -S -t aarch64-linux-gnueabi
RUN crossdev -S -t arm-linux-gnueabi
RUN crossdev -S -t i686-pc-linux-gnu
RUN crossdev -S -t powerpc-linux-gnu

# Linux+musl
RUN crossdev -S -t arm-linux-musleabi
# RUN crossdev -S -t i686-pc-linux-musl
RUN crossdev -S -t x86_64-pc-linux-musl

# Linux+uclibc
# RUN crossdev -S -t aarch64-linux-uclibceabi
# RUN crossdev -S -t arm-linux-uclibceabi
RUN crossdev -S -t i686-pc-linux-uclibc
RUN crossdev -S -t x86_64-pc-linux-uclibc

# Windows
# RUN crossdev -S -t aarch64-wince-pe
# RUN crossdev -S -t aarch64-winnt-pe
# RUN crossdev -S -t arm-wince-pe
# RUN crossdev -S -t arm-winnt-pe
# RUN crossdev -S -t i686-wince-pe
# RUN crossdev -S -t i686-winnt-pe
# RUN crossdev -S -t x86_64-wince-pe
# RUN crossdev -S -t x86_64-winnt-pe

# PowerPC
# RUN crossdev -S -t powerpc-wrs-vxworks
