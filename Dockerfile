FROM ubuntu:18.04

ENV TZ=Europe/Lisbon

# Install dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential wget autoconf automake libtool liblivemedia-dev libjson-c-dev pkg-config build-essential libssl-dev zlib1g-dev libncurses5-dev libncursesw5-dev libreadline-dev libsqlite3-dev libgdbm-dev libdb5.3-dev libbz2-dev libexpat1-dev liblzma-dev tk-dev libffi-dev && \
    wget https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tar.xz -O /tmp/Python-3.11.9.tar.xz && \
    tar -xf /tmp/Python-3.11.9.tar.xz -C /tmp && \
    cd /tmp/Python-3.11.9 && \
    ./configure --enable-optimizations && \
    make -j`nproc --all` && \
    make install && \
    rm -rf /tmp/Python-3.11.9 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# Install python-miio
RUN pip3 install python-miio

COPY . /code

WORKDIR /code

RUN sh autogen.sh && make -j`nproc --all` && make install

# CMD ["video2proxy"]
# run code
CMD videop2proxy --ip $IP --token $TOKEN --rtsp 8554

# expose port
EXPOSE 8554
