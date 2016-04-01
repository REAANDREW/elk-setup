scp -o StrictHostKeyChecking=no vagrant@192.168.56.40:/etc/pki/tls/certs/logstash-forwarder.crt /tmp

sudo mkdir -p /etc/pki/tls/certs
sudo cp /tmp/logstash-forwarder.crt /etc/pki/tls/certs/

echo "deb https://packages.elastic.co/beats/apt stable main" |  sudo tee -a /etc/apt/sources.list.d/beats.list

wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

sudo apt-get update
sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -y filebeat

sudo cp /vagrant/files/filebeat.yml /etc/filebeat/filebeat.yml

sudo service filebeat restart
sudo update-rc.d filebeat defaults 95 10

sudo apt-get -y install topbeat
sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -y topbeat

sudo cp /vagrant/files/topbeat.yml /etc/topbeat/topbeat.yml
sudo service topbeat restart
sudo update-rc.d topbeat defaults 95 10

sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -y packetbeat
sudo cp /vagrant/files/packetbeat.yml /etc/packetbeat/packetbeat.yml
sudo service packetbeat restart
sudo update-rc.d topbeat defaults 95 10
