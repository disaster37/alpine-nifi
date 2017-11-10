FROM alpine:3.6
MAINTAINER Sebastien LANGOUREAUX (linuxworkgroup@hotmail.com)

# Application settings
ENV CONFD_PREFIX_KEY="/nifi" \
    CONFD_BACKEND="env" \
    CONFD_INTERVAL="60" \
    CONFD_NODES="" \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    LANG="en_US.utf8" \
    APP_HOME="/opt/nifi" \
    APP_VERSION="1.4.0" \
    SCHEDULER_VOLUME="/opt/scheduler" \
    USER=nifi \
    GROUP=nifi \
    UID=10003 \
    GID=10003 \
    CONTAINER_NAME="alpine-nifi" \
    CONTAINER_AUHTOR="Sebastien LANGOUREAUX <linuxworkgroup@hotmail.com>" \
    CONTAINER_SUPPORT="https://github.com/disaster37/alpine-nifi/issues" \
    APP_WEB="https://nifi.apache.org"

# Install extra package
RUN apk --update add fping curl bash openjdk8-jre-base &&\
    rm -rf /var/cache/apk/*

# Install confd
ENV CONFD_VERSION="0.14.0" \
    CONFD_HOME="/opt/confd"
RUN mkdir -p "${CONFD_HOME}/etc/conf.d" "${CONFD_HOME}/etc/templates" "${CONFD_HOME}/log" "${CONFD_HOME}/bin" &&\
    curl -Lo "${CONFD_HOME}/bin/confd" "https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64" &&\
    chmod +x "${CONFD_HOME}/bin/confd"

# Install s6-overlay
RUN curl -sL https://github.com/just-containers/s6-overlay/releases/download/v1.19.1.1/s6-overlay-amd64.tar.gz \
    | tar -zx -C /




# Install Nifi software
RUN \
    mkdir -p ${APP_HOME} /data  && \
    curl https://archive.apache.org/dist//nifi/${APP_VERSION}/nifi-${APP_VERSION}-bin.tar.gz -o /tmp/nifi.tar.gz &&\
    tar -xzf /tmp/nifi.tar.gz -C /tmp &&\
    mv /tmp/nifi-*/* ${APP_HOME}/ &&\
    rm -rf /tmp/nifi* &&\
    addgroup -g ${GID} ${GROUP} && \
    adduser -g "${USER} user" -D -h ${APP_HOME} -G ${GROUP} -s /bin/sh -u ${UID} ${USER}


ADD root /
RUN chown -R ${USER}:${GROUP} ${APP_HOME}


VOLUME ["/data"]
EXPOSE 8080 8181
CMD ["/init"]