#Install Memcached
sudo apt-get install -y memcached
sed -i 's/-l 127.0.0.1/-l 0.0.0.0/g' 
sudo service memcached restart
