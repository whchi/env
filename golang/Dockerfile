FROM golang:1.16.5-buster

RUN apt -y update && apt -y upgrade

WORKDIR /app

COPY . /app

EXPOSE 8080/tcp
