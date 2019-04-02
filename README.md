# Install CMSysBot server

## Install Docker

Download docker using the official script

`wget https://get.docker.com/ -O install_docker.sh`

Add executable permissions to the script

`chmod +x install_docker.sh`

Install docker

`sudo ./install_docker.sh`

## Download CMSysBot

Get this project from GitHub

`git clone https://github.com/oddworldng/cmsysbot-docker`

## Add group privileges

Create the docker group

`sudo groupadd docker`

Add your user to the docker group

`sudo usermod -aG docker $USER`


## Build Docker container
`docker build -t cmsysbot:latest cmsysbot-docker`

## See Docker local images
`docker image ls`

## Run Docker container
`docker run --name cmsysbot -p 4444:22 cmsysbot:latest`
