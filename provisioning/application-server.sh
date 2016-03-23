sudo mkdir -p /etc/pki/tls/certs
sudo cp /tmp/logstash-forwarder.crt /etc/pki/tls/certs/


echo "deb https://packages.elastic.co/beats/apt stable main" |  sudo tee -a /etc/apt/sources.list.d/beats.list

wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

sudo apt-get update
sudo apt-get install filebeat

sudo cp /vagrant/files/filebeat.yml /etc/filebeat/filebeat.yml

sudo service filebeat restart
sudo update-rc.d filebeat defaults 95 10
