#! /bin/bash
cd /
rm -r radio_config
echo "--------------- getting config bucket"
gsutil cp -r gs://radiomolecula-nginx-config .
mv radiomolecula-nginx-config radio_config

echo "startup: docker install  --------------- "
docker_version=$(docker --version | grep "Docker version")

if [ -n "$docker_version" -eq 0 ]
then
  echo "startup: docker installed already --------------- "
# https://fabianlee.org/2017/03/07/docker-installing-docker-ce-on-ubuntu-14-04-and-16-04/
else
  sudo apt-get update
  sudo apt-get install linux-image-extra-virtual
  sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install -y docker-ce
fi

# create network
echo "startup: create docker network  --------------- "
sudo docker network create skynet

cd /radio_config

# create stunnel image on network with port exposed 19350
stunnel_service=$(sudo docker ps -a -q -f "name=stunnel-service")
if [ -n "$stunnel_service" ]
then
  echo "startup: restarting stunnel container  --------------- "
  sudo docker start $stunnel_service
else
  echo "startup: creating stunnel container  --------------- "
  sudo docker build -t stunnel-image stunnel-service
  sudo docker run -d -p 19350:19350 \
    --network skynet \
    --name stunnel-service stunnel-image;
fi

server=$(sudo docker ps -a -q -f "name=stream-server")
if [ -n "$server" ]
then
  echo "startup: restarting stream-server  --------------- "
  sudo docker start $server
else
  echo "startup: docker build stream-image --------------- "
  sudo docker build -t stream-server-image nginx-rtmp-service
  echo "startup: docker build stream-server  --------------- "
  sudo docker run -d -p 1935:1935 \
    --network skynet \
    -e STUNNEL_URL=stunnel-service:19530 \
    --env-file env_nginx \
    --name stream-server stream-server-image;
fi

container_id=$(sudo docker ps -a -q -f "name=stream-server" -f "status=running")
if [ -n "$container_id" ]
then
  echo "startup: stream-server should be up ${container_id}"
else
  echo "startup: error stream-server is NOT started"
fi
