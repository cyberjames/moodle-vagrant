# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

confDir = $confDir ||= File.expand_path(File.dirname(__FILE__))
yamlPath = confDir + "/moodle-vagrant.yaml"

Vagrant.require_version '>= 1.9.0'

Vagrant.configure(2) do |config|
    if File.exist? yamlPath then
        settings = YAML::load(File.read(yamlPath))
    else
        abort "Moodle vagrant settings file not found in #{confDir}"
    end

    hostname = settings["hostname"] ||= 'moodle.local'
	config.vm.hostname = hostname
	config.vm.box = "ubuntu/xenial64"

    httpPort = 80
    # Map ports.
    if settings.include? 'ports'
        settings["ports"].each do |port|
            if (port["guest"] == 80)
                httpPort = port["host"]
            end
            config.vm.network :forwarded_port, guest: port["guest"], host: port["host"]
        end
    end
    config.vm.synced_folder ".", "/vagrant", create: true

	config.vm.provider "virtualbox" do |vb|
		vb.customize ["modifyvm", :id, "--name", "moodle"]
		vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "4096"]
        vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "2"]
	end

	# Set up box. Install LAMP, PostgreSQL, and MDK.
	config.vm.provision  :shell, :path => "provision.sh", :args => [hostname]
    githubUsername = settings["github_username"] ||= "YourGitHub"
    minVersion = settings["min_version"] ||= 0
	config.vm.provision  :shell, :path => "initmdk.sh", :args => [githubUsername, httpPort, minVersion], :privileged => false

end
