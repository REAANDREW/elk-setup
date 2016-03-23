# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

   #config.vm.box = "centos/7"
   config.vm.box = "ubuntu/vivid64"
   config.ssh.forward_agent = true

   config.vm.define "elk-server" do |node|
       node.vm.network "private_network", ip: "192.168.56.40"
       node.vm.provision "file", source: "./keys/private/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
       node.vm.provision "file", source: "./keys/public/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
       node.vm.provision "file", source: "./keys/public/id_rsa.pub", destination: "~/.ssh/remote.pub"
       node.vm.provision "shell", inline: "cat ~vagrant/.ssh/remote.pub >> ~vagrant/.ssh/authorized_keys"
       node.vm.provider :virtualbox do |vb|
           vb.name = "elk"
           vb.customize ["modifyvm", :id, "--vram", "64"]
           vb.customize ["modifyvm", :id, "--memory", "4092"]
           vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
       end
       node.vm.provision "shell", path: "./provisioning/elk-server.sh"
   end

   config.vm.define "db-server" do |node|
       node.vm.network "private_network", ip: "192.168.56.51"
       node.vm.provision "file", source: "./keys/public/id_rsa.pub", destination: "~/.ssh/remote.pub"
       node.vm.provision "shell", inline: "cat ~vagrant/.ssh/remote.pub >> ~vagrant/.ssh/authorized_keys"
       node.vm.provider :virtualbox do |vb|
           vb.name = "db"
           vb.customize ["modifyvm", :id, "--vram", "64"]
           vb.customize ["modifyvm", :id, "--memory", "4092"]
           vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
       end
       node.vm.provision "shell", path: "./provisioning/db-server.sh"
   end

   config.vm.define "application-server" do |node|
       node.vm.network "private_network", ip: "192.168.56.50"
       node.vm.provision "file", source: "./keys/public/id_rsa.pub", destination: "~/.ssh/remote.pub"
       node.vm.provision "shell", inline: "cat ~vagrant/.ssh/remote.pub >> ~vagrant/.ssh/authorized_keys"
       node.vm.provider :virtualbox do |vb|
           vb.name = "app"
           vb.customize ["modifyvm", :id, "--vram", "64"]
           vb.customize ["modifyvm", :id, "--memory", "4092"]
           vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
       end
       node.vm.provision "shell", path: "./provisioning/application-server.sh"
   end

end
