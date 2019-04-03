# Install CMSysBot server

## Install Docker

Download docker using the official script

`wget https://get.docker.com/ -O install_docker.sh`

Add executable permissions to the script

`chmod +x install_docker.sh`

Install docker

`sudo ./install_docker.sh`

## Add group privileges

Create the docker group

`sudo groupadd docker`

Add your user to the docker group

`sudo usermod -aG docker $USER`

## Download CMSysBot

Get this project from Docker Hub

`docker pull oddworldng/cmsysbot-docker`

## See Docker local images
`docker image ls`

## Run Docker container
`docker run -it -d -p 4444:22 -e config=config.json oddworldng/cmsysbot-docker`

## Configure CMSysBot

Get docker ID

`docker ps`

Copy config.json into docker container

`docker cp -a config.json CONTAINER_ID:/opt/cmsysbot/config/`

Get into the container

`docker exec -i -t CONTAINER_ID /bin/bash`
