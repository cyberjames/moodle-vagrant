# moodle-vagrant
Moodle Vagrant installer 
(Ubuntu 16.04, Apache, PHP7, PostgreSQL, MySQL, MDK, Moodle Dev and Integration instances)

This is perfect for local testing and development installations.

Requirements:

- Vagrant ( https://www.vagrantup.com/downloads.html )
- vagrant-vbguest ( https://github.com/dotless-de/vagrant-vbguest )
- VirtualBox ( https://www.virtualbox.org/ )

Usage instructions:

- Clone moodle-vagrant:

git clone https://github.com/junpataleta/moodle-vagrant.git

- Change to moodle-vagrant directory

cd moodle-vagrant

- Initialise moodle-vagrant

On Linux: ./init.sh

On Windows: init.bat

- Edit moodle-vagrant.yaml. You may want to set your Github username and the minimum Moodle version that MDK will install.

- Execute vagrant:

vagrant up

Moodle development and integration instances from the minimum Moodle version up to the master branch will be installed by MDK.

- Development sites:

http://localhost:8080/stable_master

...

http://localhost:8080/stable_[min_version]

- Integration sites:

http://localhost:8080/integration_master

...

http://localhost:8080/integration_[min_version]
