FROM python:3.8.6-alpine

RUN apk add postgresql-dev gcc musl-dev build-base
RUN pip install uvloop==0.14.0 cytoolz==0.11.0

WORKDIR /app

COPY requirements.txt .

RUN apk add postgresql-dev gcc musl-dev

RUN apk add build-base && \
    pip install -r requirements.txt && \
    apk del build-base gcc

RUN rm -rf /var/cache/apk/*

EXPOSE 8000
