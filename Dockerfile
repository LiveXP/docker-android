FROM java:openjdk-8-jdk
MAINTAINER LiveXP <dev@livexp.fr>

ENV ANDROID_SDK_VERSION 25.2.5
ENV ANDROID_SDK_PATH /usr/local/bin/android-sdk
ENV ANDROID_API_LEVELS android-16,android-17,android-18,android-19,android-20,android-21,android-22,android-23,android-24,android-25

RUN update-ca-certificates -f

RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install -y lib32z1 libc6:i386 libncurses5:i386 libstdc++6:i386

COPY bin /usr/local/bin
RUN chmod 755 /usr/local/bin/docker-android-sdk-install
RUN mkdir -p ${ANDROID_SDK_PATH}

RUN wget https://dl.google.com/android/repository/tools_r${ANDROID_SDK_VERSION}-linux.zip && \
    unzip tools_r${ANDROID_SDK_VERSION}-linux.zip && \
    mv tools ${ANDROID_SDK_PATH} && \
    rm tools_r${ANDROID_SDK_VERSION}-linux.zip

ENV ANDROID_HOME /usr/local/bin/android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

RUN docker-android-sdk-install platform-tools,${ANDROID_API_LEVELS}

RUN rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean
