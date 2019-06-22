#! /bin/bash
cd /
rm -r radio_config
echo "--------------- getting config bucket"
gsutil cp -r gs://radiomolecula-nginx-config .
mv radiomolecula-nginx-config radio_config

echo "--------------- docker install"
sudo apt-get install -y docker.io

server=$(sudo docker ps -a -q -f "name=radiomolecula-server")
if [ -n "$server" ]
then
  echo "--------------- restarting radiomolecula-server"
  sudo docker start $server
else
  echo "--------------- docker build radiomolecula-image"
  sudo docker build -t radiomolecula-image radio_config
  echo "--------------- docker build radiomolecula-server"
  sudo docker run -d -p 1935:1935 --name radiomolecula-server radiomolecula-image
fi
container_id=$(sudo docker ps -a -q -f "name=radiomolecula-server" -f "status=running")
echo "--------------- radiomolecula-server should be up ${container_id}"
