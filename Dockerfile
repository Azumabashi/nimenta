FROM nimlang/nim:1.6.8

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get -y upgrade \
  && apt-get -y install gcc make pkg-config

RUN nimble install -y nimly