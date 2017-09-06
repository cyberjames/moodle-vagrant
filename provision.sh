#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
echo "Running operating system updates..."
apt-get update
apt-get -y upgrade
echo "Installing required packages..."
apt-get -y install \
	lamp-server^ \
	postgresql \
	postgresql-client \
	php-pgsql \
	php-intl \
	php-curl \
	php-xmlrpc \
	php-soap \
	php-gd \
	php-json \
	php-cli \
	php-mcrypt \
	php-pear \
	php-xsl \
	php-zip \
	php-mbstring \
	git \
	python \
	python-pip \
	libmysqlclient-dev \
	libpq-dev \
	python-dev \
	phpmyadmin \
	phppgadmin
echo "Configuring Apache..."
rm -rf /etc/apache2/sites-enabled
rm -rf /etc/apache2/sites-available
machinename=$1
cat <<EOF > /etc/apache2/apache2.conf
Mutex file:\${APACHE_LOCK_DIR} default
PidFile \${APACHE_PID_FILE}
Timeout 300
KeepAlive On
MaxKeepAliveRequests 100
KeepAliveTimeout 5
User \${APACHE_RUN_USER}
Group \${APACHE_RUN_GROUP}
HostnameLookups Off
ErrorLog \${APACHE_LOG_DIR}/error.log
LogLevel warn
IncludeOptional mods-enabled/*.load
IncludeOptional mods-enabled/*.conf
Include ports.conf
AccessFileName .htaccess
<FilesMatch "^\.ht">
	Require all denied
</FilesMatch>
LogFormat "%v:%p %h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" vhost_combined
LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined
LogFormat "%h %l %u %t \"%r\" %>s %O" common
LogFormat "%{Referer}i -> %U" referer
LogFormat "%{User-agent}i" agent
IncludeOptional conf-enabled/*.conf
<VirtualHost *:80>
	ServerName ${machinename}
	DocumentRoot /home/ubuntu/www
	<Directory /home/ubuntu/www>
		Order allow,deny
		Allow from All
	</Directory>
</VirtualHost>
EOF
echo "Creating database..."
PGHBAFILE=$(find /etc/postgresql -name pg_hba.conf | head -n 1)
cat <<EOF > "${PGHBAFILE}"
local   all             postgres                                peer
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             all                                     peer
host    moodle          moodle          127.0.0.1/32            trust
host    all             all             127.0.0.1/32            md5
host    all             all             ::1/128                 md5
EOF
service postgresql restart
sudo -u postgres createuser -SRDU postgres moodle
echo "Moodle-SDK (MDK) installation..."
cd ~
if [ -f "get-pip.py" ]
then
    echo "get-pip.py already downloaded..."
else
    echo "Downloading get-pip.py..."
    wget https://bootstrap.pypa.io/get-pip.py
fi
python get-pip.py
echo "Installing MDK..."
pip install moodle-sdk
echo "Restarting Apache..."
service apache2 restart
ipAddress=$2
cat <<EOF
Service installed at http://${machinename}/

You will need to add a hosts file entry for:

${machinename} points to ${ipAddress}

EOF
