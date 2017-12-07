#!/bin/bash
echo "Configuring MDK..."
githubUsername=$1
httpPort=$2
minVersion=$3

# Create .moodle-sdk folder and config file, if necessary.
[ ! -d ~/.moodle-sdk ] && mkdir ~/.moodle-sdk
[ ! -f ~/.moodle-sdk/config.json ] && touch ~/.moodle-sdk/config.json

# Github and tracker config.
mdk config set diffUrlTemplate https://github.com/${githubUsername}/moodle/compare/%headcommit%...%branch%
mdk config set remotes.mine git@github.com:${githubUsername}/moodle.git
mdk config set repositoryUrl git://github.com/${githubUsername}/moodle.git

# DB config.
mdk config set defaultEngine pgsql
mdk config set db.pgsql.user postgres
mdk config set db.pgsql.passwd moodle
mdk config set db.mysqli.user root
mdk config set db.mysqli.passwd moodle

# Directories.
[ ! -d ~/moodles ] && mkdir ~/moodles
cd ~/moodles
moodlesDir=$(pwd)

[ ! -d ~/www ] && mkdir ~/www
cd ~/www
wwwDir=$(pwd)

mdk config set path
mdk config set dirs.storage ${moodlesDir}
mdk config set dirs.www ${wwwDir}

# Set host information (used for $CFG->wwwroot).
mdkHost=localhost
if [ $httpPort -ne 80 ] && [ $httpPort -ne 443 ]; then
    # Attach port if the host will not be using the standard HTTP/HTTPS ports.
    mdkHost=${mdkHost}:${httpPort}
fi
mdk config set host $mdkHost

echo "Installing Moodle instances..."

masterBranch=$(mdk config show masterBranch)

if [ $minVersion -eq 0 ]; then
    minVersion=$masterBranch
fi

moodleVersion=$masterBranch
while [ $moodleVersion -ge $minVersion ]; do
    tmpVersion=$moodleVersion
    if [ $tmpVersion -eq $masterBranch ]; then
        tmpVersion=master
    fi
    echo "Installing development instance ("${tmpVersion}")..."
    mdk create -i -r mindev users -v ${tmpVersion}

    echo "Installing testing instance ("${tmpVersion}")..."
    mdk create -i -r mindev users -v ${tmpVersion} --integration
    ((moodleVersion--))
done

echo "Moodle instance creation done!"
echo "You may access the following sites on your host machine via the following URLS:"

echo "Development instances:"
moodleVersion=$masterBranch
mdkScheme=$(mdk config show scheme)
while [ $moodleVersion -ge $minVersion ]; do
    tmpVersion=$moodleVersion
    if [ $tmpVersion -eq $masterBranch ]; then
        tmpVersion=master
    fi
    cat <<EOF
${mdkScheme}://${mdkHost}/stable_${tmpVersion}
EOF
    ((moodleVersion--))
done

echo "Testing instances:"
moodleVersion=$masterBranch
while [ $moodleVersion -ge $minVersion ]; do
    tmpVersion=$moodleVersion
    if [ $tmpVersion -eq $masterBranch ]; then
        tmpVersion=master
    fi
    cat <<EOF
${mdkScheme}://${mdkHost}/integration_${tmpVersion}
EOF
    ((moodleVersion--))
done

# Make sure all of the instances' config are good.
mdk doctor --fix --all

cat <<EOF
Enjoy!

EOF
