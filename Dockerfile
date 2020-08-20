ARG REG_HOSTNAME
ARG REG_FOLDER
FROM ${REG_HOSTNAME}/${REG_FOLDER}/ui5:latest
MAINTAINER Gerald Wodni <gerald.wodni@gmail.com>

WORKDIR /app

COPY . .

# copy to /app-demo for easy volume-management
# (copying from /app-demo back to /app is done by initContainer
RUN cp -R /app /app-demo

USER root
