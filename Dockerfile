FROM ubuntu
MAINTAINER mwaeckerlin

VOLUME /cordova
VOLUME /project

ENV PROJECTNAME ""
ENV DOMAIN_ID ""
ENV TITLE ""
ENV PLATFORMS android
#amazon-fireos android blackberry10 browser firefoxos ubuntu webos
ENV ANDROID_HOME=/android-sdk-linux

RUN apt-get update
RUN apt-get -y install npm click cmake libicu-dev pkg-config devscripts qtbase5-dev qtchooser qtdeclarative5-dev qtfeedback5-dev qtlocation5-dev qtmultimedia5-dev qtpim5-dev libqt5sensors5-dev qtsystems5-dev wget default-jdk expect
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN npm install node
RUN npm install -g cordova

WORKDIR /tmp
RUN wget -q $(wget -q -O- 'https://developer.android.com/sdk' | \
              sed -n 's,.*"\(https\?://.*android-sdk.*linux.*\.tgz\)".*,\1,p')
WORKDIR /
RUN tar xzf /tmp/android-sdk*linux*.tgz
RUN rm /tmp/android-sdk*linux*.tgz
RUN expect -c 'set timeout -1; spawn '${ANDROID_HOME}'/tools/android update sdk -u; expect { "Do you accept the license" { exp_send "y\r" ; exp_continue } eof }'

WORKDIR /cordova

CMD cordova create "${PROJECTNAME}" "${DOMAIN_ID}" "${TITLE}" && \
    cd "${PROJECTNAME}" && \
    cordova platform add ${PLATFORMS} && \
    cordova build
