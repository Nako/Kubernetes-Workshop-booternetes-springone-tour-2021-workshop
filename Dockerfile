FROM quay.io/eduk8s/jdk11-environment:master

RUN mkdir /home/eduk8s/bin && \
    curl -L  https://github.com/making/rsc/releases/download/0.8.1/rsc-x86_64-pc-linux --output /home/eduk8s/bin/rsc && \
    chmod +x /home/eduk8s/bin/rsc && \
    fix-permissions /home/eduk8s

COPY --chown=1001:0 . /home/eduk8s/



RUN mv /home/eduk8s/workshop /opt/workshop

RUN fix-permissions /home/eduk8s
