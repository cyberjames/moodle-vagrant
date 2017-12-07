# moodle-vagrant
Moodle Vagrant installer 
(Ubuntu 16.04, Apache, PHP7, PostgreSQL, MySQL, MDK, Moodle Dev and Integration instances)

This is perfect for local testing and development installations.

## Requirements:
- Vagrant ( https://www.vagrantup.com/downloads.html )
- VirtualBox ( https://www.virtualbox.org/ )

## Usage instructions:
1. Clone (or [download](https://github.com/junpataleta/moodle-vagrant/archive/master.zip)) moodle-vagrant:
  * `git clone https://github.com/junpataleta/moodle-vagrant.git`

2. Change to moodle-vagrant directory
  * `cd moodle-vagrant`

3. Initialise moodle-vagrant. This will generate a settings file called `moodle-vagrant.yaml`
  * On Linux: `./init.sh`
  * On Windows: `init.bat`

4. Edit **moodle-vagrant.yaml**. 
  * You may want to set your **Github username** and the **minimum Moodle version** that MDK will install.
  * **Important:** The HTTP port maps to the host machine's HTTP port 80 by default, 
  assuming that the host machine is not using the port 80. Otherwise, please change the port setting for the host machine (e.g. 8080).

5. Execute vagrant:
  * `vagrant up`

6. Have a coffee break. It might take a while.

7. Moodle development and integration instances from the minimum Moodle version up to the master branch will be installed by MDK.
 * Development sites:
   * http://localhost[:port]/stable_master
   * ...
   * http://localhost[:port]/stable_[min_version]
 * Integration sites:
   * http://localhost[:port]/integration_master
   * ...
   * http://localhost[:port]/integration_[min_version]
