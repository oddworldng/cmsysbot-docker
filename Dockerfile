# Docker file for a slim Ubuntu-based Python3 image

FROM ubuntu:latest
MAINTAINER Andrés Nacimiento <alu0100499285@ull.edu.es>
MAINTAINER David Afonso <alu0101015255@ull.edu.es>

# Install Python3
RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

# Install git
RUN apt-get install -y git

# Create CMSysBot server folder
RUN mkdir -p /opt/cmsysbot/
RUN chmod 755 -R /opt/cmsysbot/

# Clone CMSysBot project from Github
RUN git clone https://github.com/oddworldng/cmsysbot-docker /opt/cmsysbot/

# Add config.json file
COPY config_files/config.json /opt//opt/cmsysbot/config/config.json

# SSH server
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN echo 'root:cmsysbot' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Few handy utilities which are nice to have
RUN apt-get -y install vim less --no-install-recommends

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN apt-get clean
# VOLUME [ "/opt/cmsysbot/" ]

# Open SSH port
EXPOSE 22

# Define default command
CMD ["/usr/sbin/sshd", "-D"]
