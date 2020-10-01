# 1st stage compile daisy
FROM ubuntu:20.04 as build

# run as root user
USER root

ENV DEBIAN_FRONTEND noninteractive

# install packages
RUN apt-get update && apt-get install -y \
    apt-utils \
    wget \
    bzip2 \
    ca-certificates \
    locales \
    time \
    mc \
    git \
    libzmq3-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    curl \
    nano \
    vim \
    build-essential \
    libboost-all-dev \
    libcxsparse3 \
    libsuitesparse-dev

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

ENV SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8


WORKDIR /root
RUN git clone https://github.com/perabrahamsen/daisy-model.git daisy
WORKDIR /root/daisy
RUN make -j`nproc` linux
RUN strip obj/daisy



# 2nd stage build daisy image
FROM ubuntu:20.04

# run as root user
USER root

ENV DEBIAN_FRONTEND noninteractive

# install packages
RUN apt-get update && apt-get install -y \
    apt-utils \
    wget \
    bzip2 \
    ca-certificates \
    locales \
    time \
    mc \
    curl \
    nano \
    neovim \
    vim \
    libcxsparse3

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen


ENV SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8


# copy compiled binary package
RUN mkdir -p /opt/daisy/bin
COPY --from=build /root/daisy/obj/daisy /opt/daisy/bin
COPY --from=build /root/daisy/lib       /opt/daisy/lib
COPY --from=build /root/daisy/sample    /opt/daisy/sample

# initial dir to run samples successfully
WORKDIR /opt/daisy/sample

ENV PATH="/opt/daisy/bin:${PATH}"

# redirect log to stdout
RUN touch /opt/daisy/daisy.log && \
    ln -sf /proc/1/fd/1 /opt/daisy/daisy.log


ENTRYPOINT [ "/opt/daisy/bin/daisy" ]
