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
    apt-get install -y python2.7 python-pip python-dev libffi-dev libssl-dev && \
    pip install --upgrade setuptools && \
    pip install pwntools && \
    groupadd -r pwntools && \
    useradd -rg pwntools pwntools

USER pwntools
