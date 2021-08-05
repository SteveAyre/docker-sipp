FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y build-essential cmake libssl-dev libpcap-dev libsctp-dev libncurses5-dev

ADD https://github.com/SIPp/sipp/releases/download/v3.6.1/sipp-3.6.1.tar.gz /
RUN tar -xf /sipp-3.6.1.tar.gz

WORKDIR /sipp-3.6.1
RUN ./build.sh --full
RUN make install

WORKDIR /
RUN rm -rf sipp-*

WORKDIR /sipp

EXPOSE 5060

ENTRYPOINT ["sipp"]
