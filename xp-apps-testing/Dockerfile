# Base image
FROM enonic/java8

USER root

RUN apt-get update
RUN apt-get -y install unzip

ENV DEBIAN_FRONTEND noninteractive
RUN DEBIAN_FRONTEND="noninteractive"
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs

RUN npm install --global gulp-cli
RUN npm install --global gulp
RUN apt-get install -y git
