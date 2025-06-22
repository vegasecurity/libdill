FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    autoconf \
    automake \
    libtool \
    pkg-config \
    tini \
    && rm -rf /var/lib/apt/lists/*


COPY m4 /opt/libdill/m4
COPY man /opt/libdill/man
COPY configure.ac Makefile.am autogen.sh package_version.sh abi_version.sh libdill.h libdill.pc.in /opt/libdill/
WORKDIR /opt/libdill

RUN ./autogen.sh && \
    ./configure

COPY *.c.inc /opt/libdill
COPY *.h.inc /opt/libdill
COPY perf/ /opt/libdill/perf
COPY dns/ /opt/libdill/dns
COPY tutorial/ /opt/libdill/tutorial

COPY *.h /opt/libdill
COPY *.c /opt/libdill
COPY examples/ /opt/libdill/examples

RUN make -j12

EXPOSE 8080 8081

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["examples/webapp"]
