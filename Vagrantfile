Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "90", "--memory", "4096", "--cpus", "2"]
  end
end
