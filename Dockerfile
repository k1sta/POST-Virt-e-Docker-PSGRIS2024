FROM arm32v7/debian:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc-arm-linux-gnueabihf \
    crossbuild-essential-armhf \
    qemu-user \
    ca-certificates \
    libc6-dev-armhf-cross \
    && rm -rf /var/lib/apt/lists/*

COPY olaMundo.c .

RUN arm-linux-gnueabihf-gcc -o olaMundo olaMundo.c

CMD ["qemu-arm", "./olaMundo"]