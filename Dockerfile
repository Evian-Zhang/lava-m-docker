FROM ubuntu:22.04

ARG MY_USERNAME
ENV MY_USERNAME ${MY_USERNAME}

WORKDIR /root/tmp

COPY build.sh .

RUN ./build.sh
