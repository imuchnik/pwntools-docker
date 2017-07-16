FROM ubuntu:14.04.5
MAINTAINER Robert Larsen <robert@the-playground.dk>

ENV TERM linux

# Install packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common && \
    apt-add-repository -y ppa:pwntools/binutils && \
    apt-add-repository -y ppa:fkrull/deadsnakes-python2.7 && \
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

# Install pwntools
RUN git clone -b 3.7.1 https://github.com/Gallopsled/pwntools.git && \
    pip install --upgrade --editable pwntools

# Install z3
RUN git clone https://github.com/Z3Prover/z3.git && \
    cd z3 && \
    python scripts/mk_make.py --python && \
    cd build && \
    make && \
    make install && \
    cd / && \
    rm -rf z3

WORKDIR /work
USER pwntools
