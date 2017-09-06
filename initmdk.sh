#!/bin/bash
echo "MDK Initial configuration..."
githubUsername=$1
mdk init --force <<EOF



${githubUsername}


postgres
moodle

EOF
echo "Installing Moodle (master)..."
mdk config set defaultEngine pgsql
mdk config set path
machinename=$2
mdk config set host ${machinename}
echo "Create development instance..."
mdk create
echo "Create testing instance..."
mdk create --integration
ipAddress=$3
cat <<EOF
Moodle (master) created and installed
You may access it via http://${machinename}/stable_master

Note that you will need to add a hosts file entry where ${machinename} points to ${ipAddress}

Enjoy!

EOF
