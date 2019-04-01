# Docker file for a slim Ubuntu-based Python3 image

FROM ubuntu:latest
MAINTAINER Andrés Nacimiento <alu0100499285@ull.edu.es>
MAINTAINER David Afonso <alu0101015255@ull.edu.es>

RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

# Install git
RUN apt-get install -y git

# Create CMSysBot server folder
RUN mkdir -p /opt/cmsysbot/

# Clone CMSysBot project from Github
RUN git clone git@github.com:whatever /opt/cmsysbot/

# Add config.json file
COPY config_files/config.json /opt//opt/cmsysbot/config/config.json

# SSH server
RUN apt-get install -y -q supervisor openssh-server
RUN mkdir -p /var/run/sshd

# Output supervisor config file to start openssh-server
RUN echo "[program:openssh-server]" >> /etc/supervisor/conf.d/supervisord-openssh-server.conf
RUN echo "command=/usr/sbin/sshd -D" >> /etc/supervisor/conf.d/supervisord-openssh-server.conf
RUN echo "numprocs=1" >> /etc/supervisor/conf.d/supervisord-openssh-server.conf
RUN echo "autostart=true" >> /etc/supervisor/conf.d/supervisord-openssh-server.conf
RUN echo "autorestart=true" >> /etc/supervisor/conf.d/supervisord-openssh-server.conf

# Allow root login via password
# root password is: root
RUN sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# Set root password
# password hash generated using this command: openssl passwd -1 -salt xampp root
RUN sed -ri 's/root\:\*/root\:\$1\$xampp\$5\/7SXMYAMmS68bAy94B5f\./g' /etc/shadow

# Few handy utilities which are nice to have
RUN apt-get -y install vim less --no-install-recommends

RUN apt-get clean
VOLUME [ "/opt/cmsysbot/" ]

# Run CMSysBot
CMD ["make", "/opt/cmsysbot/"]
