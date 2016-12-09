FROM ubuntu:14.04
MAINTAINER Robert Larsen <robert@the-playground.dk>

ENV TERM linux
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common && \
    apt-add-repository -y ppa:pwntools/binutils && \
    apt-get update && \
    apt-get install -y binutils-arm-linux-gnu \
                       binutils-i386-linux-gnu \
                       binutils-mips-linux-gnu \
                       binutils-mips64-linux-gnu && \
    apt-get install -y git python2.7 python-pip python-dev libffi-dev libssl-dev && \
    pip install --upgrade setuptools && \
    pip install requests && \
    groupadd -r pwntools && \
    useradd -mrg pwntools pwntools && \
    rm -rf /var/lib/apt/lists/*
RUN git clone -b 3.2.0 https://github.com/Gallopsled/pwntools.git && \
    pip install --upgrade --editable pwntools

WORKDIR /work
USER pwntools
