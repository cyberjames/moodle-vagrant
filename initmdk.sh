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
mdk create -i -r mindev user
cat <<EOF
Moodle (master) created and installed
You may access it via http://${machinename}/stable_master

Enjoy!

EOF
