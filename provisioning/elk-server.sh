sudo apt-get install -y python-software-properties

sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update

# Enable silent install
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

sudo apt-get -y install oracle-java8-installer
sudo echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

# Not always necessary, but just in case...
sudo update-java-alternatives -s java-8-oracle

# Setting Java environment variables
sudo apt-get install -y oracle-java8-set-default
sudo apt-get update

sudo wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
sudo apt-get update
sudo apt-get -y install elasticsearch
sudo cp /vagrant/files/elasticsearch.yml /etc/elasticsearch/
sudo service elasticsearch restart
sudo update-rc.d elasticsearch defaults 95 10


echo "deb http://packages.elastic.co/kibana/4.4/debian stable main" | sudo tee -a /etc/apt/sources.list.d/kibana-4.4.x.list
sudo apt-get update
sudo apt-get -y install kibana
sudo cp /vagrant/files/kibana.yml /opt/kibana/config/
sudo update-rc.d kibana defaults 96 9
sudo service kibana start

sudo apt-get -y install nginx apache2-utils
printf "kibanaadmin:$(openssl passwd -crypt 123abc1234)\n" >> .htpasswd
sudo cp .htpasswd /etc/nginx/htpasswd.users
sudo cp /vagrant/files/nginx.default /etc/nginx/sites-available/default
sudo service nginx restart

echo 'deb http://packages.elastic.co/logstash/2.2/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash-2.2.x.list
sudo apt-get update
sudo apt-get install logstash

sudo mkdir -p /etc/pki/tls/certs
sudo mkdir -p /etc/pki/tls/private

if ! grep -Fxq "subjectAltName = IP: 192.168.56.40" /etc/ssl/openssl.cnf
then
    sed -i 's/\[ v3_ca \]/[ v3_ca ]\nsubjectAltName = IP: 192.168.56.40/g' /etc/ssl/openssl.cnf
fi
cd /etc/pki/tls
sudo openssl req -config /etc/ssl/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt

sudo cp /vagrant/files/02-beats-input.conf /etc/logstash/conf.d/02-beats-input.conf
sudo cp /vagrant/files/10-syslog-filter.conf /etc/logstash/conf.d/10-syslog-filter.conf
sudo cp /vagrant/files/30-elasticsearch-output.conf /etc/logstash/conf.d/30-elasticsearch-output.conf

sudo service logstash configtest
sudo service logstash restart
sudo update-rc.d logstash defaults 96 9

#Setup the dashboards
cd ~
curl -L -O https://download.elastic.co/beats/dashboards/beats-dashboards-1.1.0.zip
sudo apt-get -y install unzip
unzip beats-dashboards-*.zip
cd beats-dashboards-*
./load.sh

cd ~
curl -O https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json
curl -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@filebeat-index-template.json

scp /etc/pki/tls/certs/logstash-forwarder.crt vagrant@192.168.56.50:/tmp
