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
	ipAddress = settings["ip"] ||= "192.168.33.10"
	config.vm.network "private_network", ip: ipAddress
	config.vm.synced_folder ".", "/vagrant", create: true

	# Register All Of The Configured Shared Folders
    if settings.include? 'folders'
        settings["folders"].each do |folder|
            if File.exists? File.expand_path(folder["map"])
                mount_opts = []

                if (folder["type"] == "nfs")
                    mount_opts = folder["mount_options"] ? folder["mount_options"] : ['actimeo=1', 'nolock']
                elsif (folder["type"] == "smb")
                    mount_opts = folder["mount_options"] ? folder["mount_options"] : ['vers=3.02', 'mfsymlinks']
                end

                # For b/w compatibility keep separate 'mount_opts', but merge with options
                options = (folder["options"] || {}).merge({ mount_options: mount_opts })

                # Double-splat (**) operator only works with symbol keys, so convert
                options.keys.each{|k| options[k.to_sym] = options.delete(k) }

                config.vm.synced_folder folder["map"], folder["to"], type: folder["type"] ||= nil, **options

                # Bindfs support to fix shared folder (NFS) permission issue on Mac
                if Vagrant.has_plugin?("vagrant-bindfs")
                    config.bindfs.bind_folder folder["to"], folder["to"]
                end
            else
                config.vm.provision "shell" do |s|
                    s.inline = ">&2 echo \"Unable to mount one of your folders. Please check your folders in Homestead.yaml\""
                end
            end
        end
    end

	config.vm.provider "virtualbox" do |vb|
		vb.customize ["modifyvm", :id, "--name", "moodle"]
		vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
        vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
	end

	# Set up box. Install Apache, PostgreSQL, and MDK.
	config.vm.provision  :shell, :path => "provision.sh", :args => [hostname, ipAddress]
    githubUsername = settings["github_username"] ||= "YourGitHub"
	config.vm.provision  :shell, :path => "initmdk.sh", :args => [githubUsername, hostname, ipAddress], :privileged => false

end
