FROM ubuntu:20.04

# for the browser VNC client
EXPOSE 5901

# Make sure the dependencies are met
ENV APT_INSTALL_PRE="apt -o Acquire::ForceIPv4=true update && DEBIAN_FRONTEND=noninteractive apt -o Acquire::ForceIPv4=true install -y --no-install-recommends"
ENV APT_INSTALL_POST="&& apt clean -y && rm -rf /var/lib/apt/lists/*"
# Make sure the dependencies are met
RUN eval ${APT_INSTALL_PRE} tigervnc-standalone-server tigervnc-common git net-tools python python-numpy ca-certificates scrot openbox wget xz-utils curl sudo busybox supervisor psmisc jq moreutils firefox fonts-droid-fallback xfce4-terminal locales fonts-noto-color-emoji wget libnss3-tools${APT_INSTALL_POST}

# Install VNC. Requires net-tools, python and python-numpy
RUN git clone --branch v1.2.0 --single-branch https://github.com/novnc/noVNC.git /opt/noVNC
RUN git clone --branch v0.9.0 --single-branch https://github.com/novnc/websockify.git /opt/noVNC/utils/websockify
RUN ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# Set timezone to UTC
RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo UTC > /etc/timezone

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Add in non-root user
ENV UID_OF_DOCKERUSER 1000
RUN useradd -m -s /bin/bash -g users -u ${UID_OF_DOCKERUSER} dockerUser && usermod -a -G sudo dockerUser
RUN chown -R dockerUser:users /home/dockerUser && chown dockerUser:users /opt

ENV PASSWORD=password
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN cd /tmp &&\
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&\
    dpkg -i google-chrome-stable_current_amd64.deb ;apt update ; apt install -f -y ;apt install -y fonts-droid-fallback;

RUN wget https://snapshots.mitmproxy.org/7.0.4/mitmproxy-7.0.4-linux.tar.gz -O /tmp/mitmproxy.tar.gz  && \
    tar zxvf  /tmp/mitmproxy.tar.gz -C /bin/

COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY --chown=dockerUser:users container_startup.sh /opt/container_startup.sh
COPY --chown=dockerUser:users x11vnc_entrypoint.sh /opt/x11vnc_entrypoint.sh
COPY --chown=dockerUser:users import-ca.sh /bin/import-ca.sh


RUN mkdir -p /home/dockerUser/.config;chown -R 1000:1000 /home/dockerUser/.config


USER dockerUser
RUN curl https://raw.githubusercontent.com/kjelly/auto_config/master/scripts/init_nvim.sh |bash

ENTRYPOINT ["/opt/container_startup.sh"]
