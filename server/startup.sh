#! /bin/bash
echo "--------------- getting config bucket"
gsutil cp -r gs://radiomolecula-nginx-config .
mv radiomolecula-nginx-config radio_config
echo "--------------- docker install"
sudo apt-get install -y docker.io
echo "--------------- docker build radiomolecula-image"
sudo docker build -t radiomolecula-image radio_config
echo "--------------- docker build radiomolecula-server"
sudo docker run -d -p 1935:1935 --name radiomolecula-server radiomolecula-image
echo "--------------- docker run radiomolecula-server complete"

