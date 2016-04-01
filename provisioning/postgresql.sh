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
