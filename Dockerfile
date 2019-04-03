# Docker file for a slim Ubuntu-based Python3 image

FROM ubuntu:latest
MAINTAINER Andrés Nacimiento <alu0100499285@ull.edu.es>
MAINTAINER David Afonso <alu0101015255@ull.edu.es>

# Arguments
ARG password
ARG config

#ENV http_proxy host:port
#ENV https_proxy host:port

# Install Python3
RUN apt-get clean
RUN apt-get update
RUN apt-get install -y python3-pip python3-dev
RUN cd /usr/local/bin
RUN ln -s /usr/bin/python3 python
RUN pip3 install --upgrade pip

# Install git
RUN apt-get install -y git

# Create CMSysBot server folder
RUN mkdir -p /opt/cmsysbot/
RUN chmod 755 -R /opt/cmsysbot/

# Clone CMSysBot project from Github
RUN git clone https://github.com/oddworldng/cmsysbot-docker /opt/cmsysbot/

# Add config.json file
COPY ${config} /opt/cmsysbot/config/config.json

# SSH server
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN echo 'root:${password}' | chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN mkdir /root/.ssh

RUN service ssh restart

# Few handy utilities which are nice to have
RUN apt-get -y install vim less --no-install-recommends

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

# VOLUME [ "/opt/cmsysbot/log/" ]

# Run CMSysBot
RUN cd /opt/cmsysbot/
RUN make run

# Open SSH port
EXPOSE 22

# Define default command
CMD ["/usr/sbin/sshd", "-D"]
