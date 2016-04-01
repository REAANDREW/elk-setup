sudo apt-get -y install build-essential

#Install Node.js
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install -y nodejs

#(cp -r /vagrant/samples/node-postgres-todo/ /home/vagrant/ && chown -R vagrant:vagrant /home/vagrant/node-postgres-todo/ && cd node-postgres-todo && sudo npm install && sudo -u vagrant npm run-script setup)
#su - vagrant
#(cd /home/vagrant/node-postgres-todo/ && forever start ./bin/www)

applications="node-postgres-todo"

for app in $applications
do
    filename="/var/log/${app}.application.log"
    logRotateFile=$(cat "/vagrant/files/rotate-template" | sed "s/app_name/${app}/g")
    sudo touch "${filename}"
    sudo echo "rotate my log file" > "${filename}"
    sudo chown vagrant "${filename}"
    sudo logrotate -f /etc/logrotate.conf
done

