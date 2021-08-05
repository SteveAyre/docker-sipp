FROM ubuntu:latest AS builder

# build deps
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y build-essential cmake libssl-dev libpcap-dev libsctp-dev libncurses5-dev

# source
ADD https://github.com/SIPp/sipp/releases/download/v3.6.1/sipp-3.6.1.tar.gz /
RUN tar -xf /sipp-3.6.1.tar.gz
ADD patches/ /sipp-patches/

# compile
WORKDIR /sipp-3.6.1
RUN for PATCH in /sipp-patches/*.patch; do patch -p1 <$PATCH; done
RUN ./build.sh --full


FROM ubuntu:latest AS target

# binary and deps
RUN apt-get update && apt-get install -y libssl1.1 libpcap0.8-dev libsctp1 libtinfo6
COPY --from=builder /sipp-3.6.1/sipp /usr/local/bin/sipp

# run
WORKDIR /sipp
EXPOSE 5060
ENTRYPOINT ["sipp"]
