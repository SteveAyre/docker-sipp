
FROM ubuntu:latest AS builder
ARG VERSION

# build deps
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y build-essential cmake libssl-dev libpcap-dev libsctp-dev libncurses5-dev libgsl-dev uuid-dev

# source
WORKDIR /
ADD https://github.com/SIPp/sipp/releases/download/v${VERSION}/sipp-${VERSION}.tar.gz /
RUN tar -xf sipp-${VERSION}.tar.gz
RUN mv sipp-${VERSION} src
ADD patches/ /patches/

# compile
WORKDIR /src
RUN for PATCH in /patches/*.patch; do patch -p1 <$PATCH; done
RUN ./build.sh --full


FROM ubuntu:latest AS target
ARG VERSION

# binary and deps
RUN apt-get update && apt-get install -y libssl3 libpcap0.8-dev libsctp1 libtinfo6 libgsl27 libuuid1
COPY --from=builder /src/sipp /usr/local/bin/sipp
COPY --from=builder /src/pcap /sipp/pcap

# run
WORKDIR /sipp
EXPOSE 5060
ENTRYPOINT ["sipp"]
