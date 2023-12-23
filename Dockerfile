FROM ubuntu:18.04

RUN mkdir /simple-os
COPY Makefile /simple-os
COPY src/ /simple-os/src
WORKDIR /simple-os
RUN apt-get update && apt-get install -y make && apt-get install -y nasm && apt-get install -y gcc
CMD make build && cp build/os-image /output
