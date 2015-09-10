FROM ubuntu
MAINTAINER mwaeckerlin

VOLUME /cordova
VOLUME /project

ENV PROJECTNAME ""
ENV DOMAIN_ID ""
ENV TITLE ""
ENV PLATFORMS android ubuntu

RUN apt-get update
RUN apt-get -y install npm click cmake libicu-dev pkg-config devscripts qtbase5-dev qtchooser qtdeclarative5-dev qtfeedback5-dev qtlocation5-dev qtmultimedia5-dev qtpim5-dev libqt5sensors5-dev qtsystems5-dev
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN npm install node
RUN npm install -g cordova

WORKDIR /cordova
