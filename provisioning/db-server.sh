
#GENERATE LOCALES
sudo locale-gen en_GB en_GB.UTF-8

# Install MongoDB
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo cp /vagrant/files/mongod.service /lib/systemd/system/mongod.service
sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/g' /etc/mongod.conf
sudo service mongod restart

# Install Postgre

sudo apt-get -y install postgresql-9.4
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '0.0.0.0'/g" /etc/postgresql/9.4/main/postgresql.conf

line="host	all	all	192.168.56.0/24	trust"
if ! grep -Fxq "$line" /etc/postgresql/9.4/main/pg_hba.conf
then
    sudo echo $line >> /etc/postgresql/9.4/main/pg_hba.conf
fi

sudo service postgresql restart

sudo -u postgres createuser vagrant
sudo -u postgres createdb -O vagrant todo
