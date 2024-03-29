# This image provides a base for building and running WebSphere Liberty applications.
# It does a binary build
FROM clouddragons/websphere-liberty-centos:19.0.0.9-kernel

MAINTAINER David Carew <carew@us.ibm.com>

LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i \
      io.s2i.scripts-url=image:///usr/local/s2i \
      io.k8s.description="Platform for building and running JEE applications on IBM WebSphere Liberty Profile" \
      io.k8s.display-name="Liberty 19.0.0.4 javaProfile7" \
      io.openshift.expose-services="9080/tcp:http, 9443/tcp:https" \
      io.openshift.tags="runner, builder,liberty" \
      io.openshift.s2i.destination="/tmp"

ENV STI_SCRIPTS_PATH="/usr/local/s2i" \
    WORKDIR="/tmp/src" \
    WLP_DEBUG_ADDRESS="7777" \
    ENABLE_DEBUG="false" \
    ENABLE_JOLOKIA="true" \
    S2I_DESTINATION="/tmp"

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

USER root


RUN chown -R 1001:0 /config && \
    chmod -R g+rw /config && \
    chown -R 1001:0 /opt/ibm/wlp/usr/servers/defaultServer && \
    chmod -R g+rw /opt/ibm/wlp/usr/servers/defaultServer && \
    chown -R 1001:0 /opt/ibm/wlp/output && \
    chmod -R g+rw /opt/ibm/wlp/output && \
    chown -R 1001:0 /logs && \
    chmod -R g+rw /logs && \
    mkdir -p $WORKDIR/artifacts && \
    mkdir -p $WORKDIR/config && \
    chown -R 1001:0 $WORKDIR && \
    chmod -R g+rw $WORKDIR


USER 1001
COPY ./placeholder.txt $WORKDIR/artifacts
COPY ./placeholder.txt $WORKDIR/config

WORKDIR $WORKDIR

EXPOSE $WLP_DEBUG_ADDRESS

CMD ["$STI_SCRIPTS_PATH/run"]
