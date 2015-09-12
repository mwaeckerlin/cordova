FROM ubuntu
MAINTAINER mwaeckerlin

VOLUME /output
VOLUME /cordova
VOLUME /project

ENV PROJECT ""
ENV DOMAIN ""
ENV TITLE ""
ENV PLATFORMS android
#amazon-fireos android blackberry10 browser firefoxos ubuntu webos
ENV ANDROID_TARGET "android-21"
ENV ANDROID_HOME /android-sdk-linux

RUN apt-get -y install software-properties-common
RUN apt-add-repository ppa:cordova-ubuntu/ppa
RUN apt-get update
RUN apt-get -y install npm click cmake libicu-dev pkg-config devscripts qtbase5-dev qtchooser qtdeclarative5-dev qtfeedback5-dev qtlocation5-dev qtmultimedia5-dev qtpim5-dev libqt5sensors5-dev qtsystems5-dev wget default-jdk expect libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 cordova-cli

WORKDIR /tmp
RUN wget -q $(wget -q -O- 'https://developer.android.com/sdk' | \
              sed -n 's,.*"\(https\?://.*android-sdk.*linux.*\.tgz\)".*,\1,p')
WORKDIR /
RUN tar xzf /tmp/android-sdk*linux*.tgz
RUN rm /tmp/android-sdk*linux*.tgz
RUN ( sleep 5 && while [ 1 ]; do sleep 1; echo "y"; done ) | ${ANDROID_HOME}/tools/android update sdk -u
#RUN expect -c 'set timeout -1; spawn '${ANDROID_HOME}'/tools/android update sdk -u; expect { {[y/n]:} { exp_send "y\r" ; exp_continue } eof }'

WORKDIR /cordova

CMD cordova create "${PROJECT}" "${DOMAIN}" "${TITLE}" && \
    cd "${PROJECT}" && \
    cordova platform add ${PLATFORMS} && \
    if test -d platforms/android; then \
      sed -i 's,target=.*,target='${ANDROID_TARGET}',g' platforms/android/project.properties; \
    fi && \
    cordova build && \
    mv platforms/android/build/outputs/apk/android-debug.apk /output/${PROJECT}.apk && \
    echo "----> get the result with:" && \
    echo "      docker cp $(hostname):/output ." && \
    echo "and find the result in folder ./output" && \
    sleep infinity