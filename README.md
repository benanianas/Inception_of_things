# Part one

### Defining Multiple Machines in Vagrant

Multiple machines are defined within the same project Vagrantfile using the config.vm.define method call. This configuration directive is a little funny, because it creates a Vagrant configuration within a configuration. An example shows this best:

Example:
```
Vagrant.configure("2") do |config|

  config.vm.define "web" do |web|
    web.vm.box = "apache"
  end

  config.vm.define "db" do |db|
    db.vm.box = "mysql"
  end
end

```

### Static IP 

To manually set the IP of the bridged interface

```
config.vm.network "public_network", ip: "192.168.42.110"
```

### Provider Configuration

Multiple config.vm.provider blocks can exist to configure multiple providers.

```
Vagrant.configure("2") do |config|
  # ...

  config.vm.provider "virtualbox" do |vb|
     v.name = "abenaniS"
     # OR
     #  v.customize ["modifyvm", :id, "--name", "abenaniS"]
     v.memory = 1024
     # OR
     #  v.customize ["modifyvm", :id, "--memory", "1024"]
     v.cpus = 1
     # OR
     #  v.customize ["modifyvm", :id, "--cpus", "1"]
  end
end
```

### Shell Provisioner

The Vagrant Shell provisioner allows to upload and execute a script within the guest machine.

```
Vagrant.configure("2") do |config|
  # config.vm.provision "shell", path: "./script.sh"  (script path in the host Machine)
  # OR
  config.vm.provision "shell", inline: <<-SHELL
  --Script Here--
  SHELL
end
```

### Trigger

Trigger is expected to be given a command key for when it should be fired during the Vagrant command lifecycle.
```
server.trigger.after :up do |trigger|
    trigger.run = {inline: "vagrant scp abenaniS:/vagrant/.token ."}
end
```
`trigger.run`:  to run a inline or remote script on the Host Machine

`trigger.run_remote`:   to run a inline or remote script on the guest Machine.  


### Pass Token to the Host

Token path: `/var/lib/rancher/k3s/server/node-token`

can't copy the token without sudo `echo $(sudo cat /var/lib/rancher/k3s/server/node-token) > /vagrant/.token`

In order to use vagrant scp we need to install `vagrant-scp` plugin

`vagrant plugin install vagrant-scp`

we used it using the up trigger.run to run it in the host machine within the Vagrantfile

```
vagrant scp abenaniS:/vagrant/.token .
```

### Pass node-token to the worker Machine

no need to use `vagrant scp` again , when running `vagrant up` we can find all the files from the Vagrantfile directory in the Guest Machine at the path `/vagrant/`

### K3s

Master Configuration
install master node
```
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--flannel-iface eth1" sh -s -
```

Agent Configuration

To install on worker node, we run the installation script with the K3S_URL and K3S_TOKEN environment variables.

```
 curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" K3S_URL=https://192.168.42.110:6443 K3S_TOKEN=<node-token> INSTALL_K3S_EXEC="--flannel-iface eth1" sh -s -
```
Vagrant typically assigns two interfaces to all VMs. The first, for which all hosts are assigned the IP address 10.0.2.15, is for external traffic that gets NATed.

This may lead to problems with flannel. By default, flannel selects the first interface on a host. This leads to all hosts thinking they have the same public IP address. To prevent this issue, pass the --iface=eth1 flag to flannel so that the second interface is chosen. 

[Flannel docs](https://github.com/flannel-io/flannel/blob/master/Documentation/troubleshooting.md#vagrant)
