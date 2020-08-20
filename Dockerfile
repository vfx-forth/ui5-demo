ARG REG_HOSTNAME
ARG REG_FOLDER
FROM ${REG_HOSTNAME}/${REG_FOLDER}/ui5:latest
MAINTAINER Gerald Wodni <gerald.wodni@gmail.com>

WORKDIR /app

COPY . .

USER root
