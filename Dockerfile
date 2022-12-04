FROM nimlang/nim:1.6.8

RUN apt-get update \
  && apt-get -y upgrade \
  && apt-get -y install gcc make pkg-config 

RUN nimble install nimly