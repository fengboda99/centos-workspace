Vagrant.configure("2") do |config|

  hostname = File.basename(Dir.getwd)
  config.vm.define "#{hostname}" do |app|
    app.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "1024"
      vb.cpus = 2
    end
    app.vm.hostname = "#{hostname}"
    app.vm.network "forwarded_port", guest: 5000, host: 5000
    app.vm.box = "bento/centos-7.3"
    app.vm.box_check_update = false
    app.ssh.insert_key = false
    app.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key']
    app.vm.network "private_network", ip: "10.19.19.19"
    app.vm.provision "shell", path: "prepare.sh"
  end
end
