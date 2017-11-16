# Base image
FROM enonic/java8

USER root

RUN apt-get update -qqy

ENV DEBIAN_FRONTEND noninteractive
RUN DEBIAN_FRONTEND="noninteractive"
RUN apt-get install -y unzip

RUN apt-get install -y curl

RUN curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs

RUN npm install --global gulp-cli
RUN npm install --global gulp

RUN apt-get install -y git


RUN CHROME_VERSION="google-chrome-stable"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
&& echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
&& apt-get update -qqy \
&& apt-get -qqy install \
${CHROME_VERSION:-google-chrome-stable} \
&& rm /etc/apt/sources.list.d/google-chrome.list \
&& rm -rf /var/lib/apt/lists/* /var/cache/apt/*
