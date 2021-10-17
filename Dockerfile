FROM debian

# necessary envs
ENV container docker
ARG LC_ALL=C
ARG DEBIAN_FRONTEND=noninteractive
# install systemd and ssh
RUN apt update \
    && apt install -y systemd \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# remove unnecessary units
RUN rm -f /lib/systemd/system/sysinit.target.wants/*.mount \
    && systemctl disable networkd-dispatcher.service
RUN DEBIAN_FRONTEND=noninteractive apt install firefox-esr mate-system-monitor  git lxde tightvncserver wget   -y
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz
RUN tar -xvf v1.2.0.tar.gz
RUN mkdir  /root/.vnc
RUN echo 'uncleluo' | vncpasswd -f > /root/.vnc/passwd
RUN chmod 600 /root/.vnc/passwd
RUN cp /noVNC-1.2.0/vnc.html /noVNC-1.2.0/index.html
RUN cd /root
RUN su root -l -c 'vncserver :2000 '
RUN cd /noVNC-1.2.0
RUN ./utils/launch.sh  --vnc localhost:7900 --listen 80
RUN echo root:laoluoshushu|chpasswd
STOPSIGNAL SIGRTMIN+3
WORKDIR /
VOLUME ["/sys/fs/cgroup", "/tmp", "/run", "/run/lock"]
EXPOSE 80
CMD  /sbin/init
