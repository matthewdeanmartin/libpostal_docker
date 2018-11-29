# Authors: Vladimir Loskutov, Matthew Martin

FROM ubuntu:18.04

LABEL Description="Libpostal precompiled" Vendor="N/A" Version="0.1.0"

# Install base apt packages

# This base is for python flavored app, libpostal has no dependencies on python, AFAIK.

RUN apt-get update
RUN apt-get install -y --no-install-recommends autoconf automake build-essential curl git libsnappy-dev libtool pkg-config sudo && \
    apt-get install -y --no-install-recommends python3-distutils python3-dev && \
    apt-get install -y --no-install-recommends ca-certificates byobu  && \
    apt-get install -y --no-install-recommends nano \
                        ufw net-tools iptables htop unattended-upgrades && \
    # apt-get install -y --no-install-recommends openssh-server && \
    rm -rf /var/lib/apt/lists/* && apt-get autoremove && \
    curl https://bootstrap.pypa.io/get-pip.py | python3.6 && \
    pip3 install --upgrade pip  && pip3 install wheel pipenv

RUN echo 'APT::Periodic::Update-Package-Lists "1";' >> /etc/apt/apt.conf.d/10periodic  && \
    echo 'APT::Periodic::Download-Upgradeable-Packages "1";' >> /etc/apt/apt.conf.d/10periodic && \
    echo 'APT::Periodic::AutocleanInterval "7";' >> /etc/apt/apt.conf.d/10periodic  && \
    echo 'APT::Periodic::Unattended-Upgrade "1";' >> /etc/apt/apt.conf.d/10periodic

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV HISTFILESIZE=1500
ENV HISTSIZE=1500

# Install libpostal

RUN git clone https://github.com/openvenues/libpostal
RUN cd libpostal && \
    ./bootstrap.sh && \
    ./configure --datadir=/home/micro_geocode/postal/ && \
    make && \
    sudo make install && \
    sudo ldconfig

ENTRYPOINT ["/usr/bin/env", "bash"]
CMD ["/bin/bash"]

# If you need ssh access to container then uncomment code below to generate key and configure ssh daemon

# RUN CONFIG=/etc/ssh/sshd_config ;\
#     DEFAULTS=/etc/ssh/sshd_config.factory-defaults ;\
#     if [ ! -f "$DEFAULTS" ]; then \
#         cp "$CONFIG" "$DEFAULTS" \
#         chmod a-w "$DEFAULTS" ;\
#     fi ;\
#     # change PasswordAuthentication to no
#     sed -i "s/[ \t]*#[ \t]*PasswordAuthentication[ \t]*yes/PasswordAuthentication no/" "$CONFIG" ;\
#     cat $CONFIG | grep PasswordAuthentication ;\
#     systemctl enable ssh ;\
#     service ssh start

# COPY micro_geocode.pem.pub /micro_geocode.pub
# RUN USER="micro_geocode" ;\
#     mkdir .ssh ;\
#     chmod 700 .ssh ;\
#     touch /home/"$USER"/.ssh/authorized_keys ;\
#     chmod 600 /home/"$USER"/.ssh/authorized_keys ;\
#     cat /"$USER".pub >> /home/"$USER"/.ssh/authorized_keys
