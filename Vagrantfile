# -*- mode: ruby -*-
# vi: set ft=ruby :
# To enable zsh, please set ENABLE_ZSH env var to "true" before launching vagrant up 
#   + On windows => $env:ENABLE_ZSH="true"
#   + On Linux  => export ENABLE_ZSH="true"

Vagrant.configure("2") do |config|
  config.vm.define "myhaproxy" do |myhaproxy|
    myhaproxy.vm.box = "geerlingguy/centos7"
    myhaproxy.vm.box_download_insecure=true 
    myhaproxy.vm.network "private_network", type: "static", ip: "192.168.99.10"
    myhaproxy.vm.hostname = "myhaproxy"
    myhaproxy.vm.provider "virtualbox" do |v|
      v.name = "myhaproxy"
      v.memory = 2048
      v.cpus = 1
    end
    myhaproxy.vm.provision :shell do |shell|
      shell.path = "install_tools.sh"
      shell.args = ["master", "192.168.99.10"]
      
    end
  end
  apps=2
  ram_app=2048
  cpu_app=1
  (1..apps).each do |i|
    config.vm.define "app#{i}" do |app|
      app.vm.box = "geerlingguy/centos7"
      app.vm.network "private_network", type: "static", ip: "192.168.99.1#{i}"
      app.vm.hostname = "app#{i}"
      app.vm.provider "virtualbox" do |v|
        v.name = "app#{i}"
        v.memory = ram_app
        v.cpus = cpu_app
      end
      app.vm.provision :shell do |shell|
        shell.path = "install_joomla.sh"
        shell.args = ["node", "192.168.99.10"]
      end
    end
  end
end
