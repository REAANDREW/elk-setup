sudo mkdir -p /etc/pki/tls/certs
sudo cp /tmp/logstash-forwarder.crt /etc/pki/tls/certs/

echo "deb https://packages.elastic.co/beats/apt stable main" |  sudo tee -a /etc/apt/sources.list.d/beats.list

wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

sudo apt-get update
sudo apt-get install filebeat

sudo cp /vagrant/files/filebeat.yml /etc/filebeat/filebeat.yml

sudo service filebeat restart
sudo update-rc.d filebeat defaults 95 10

sudo apt-get install topbeat

sudo cp /vagrant/files/topbeat.yml /etc/topbeat/topbeat.yml
sudo service topbeat restart
sudo update-rc.d topbeat defaults 95 10

sudo apt-get install packetbeat
sudo cp /vagrant/files/packetbeat.yml /etc/packetbeat/packetbeat.yml
sudo service packetbeat restart
sudo update-rc.d topbeat defaults 95 10

#Install Node.js
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install -y nodejs

# Start the Node.js Postgress Example Application
sudo npm install -g forever

(cp -r /vagrant/samples/node-postgres-todo/ /home/vagrant/ && chown -R vagrant:vagrant /home/vagrant/node-postgres-todo/ && cd node-postgres-todo && npm install && sudo -u vagrant npm run-script setup)

(cd /home/vagrant/node-postgres-todo/ && sudo -u vagrant forever start ./bin/www)
