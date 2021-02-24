FROM quay.io/eduk8s/jdk11-environment:master

COPY --chown=1001:0 . /home/eduk8s/

RUN curl -L  https://github.com/making/rsc/releases/download/0.8.1/rsc-x86_64-pc-linux --output /usr/bin/rsc && chmod +x /usr/bin/rsc

RUN mv /home/eduk8s/workshop /opt/workshop

RUN fix-permissions /home/eduk8s
