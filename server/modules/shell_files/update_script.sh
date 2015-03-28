#!/usr/bin/env bash
##
## a script for package information that will be wrote to the file /opt/info/systemInfo.txt
##
##
## copyright 2014 Infinite Automation All Rights Reserved
##
#!/bin/sh -e
#

evalCmd=`which eval`
pingCmd=`which ping`
awkCmd=`which awk`
sedCmd=`which sed`



# poor mans force
if [ "$1" = "--force" ]; then
    NEED_UPDATE_CHECK=yes
fi

# check time when we did the last update check
stamp="/var/lib/update-notifier/updates-available"

# get list dir
StateDir="/var/lib/apt/"
ListDir="lists/"
eval "$(apt-config shell StateDir Dir::State)"
eval "$(apt-config shell ListDir Dir::State::Lists)"

# get sources.list file
EtcDir="etc/apt/"
SourceList="sources.list"
eval "$(apt-config shell EtcDir Dir::Etc)"
eval "$(apt-config shell SourceList Dir::Etc::sourcelist)"

# check if we have a list file or sources.list that needs checking
if [ -e "$stamp" ]; then
    if [ "$(find "/$StateDir/$ListDir" "/$EtcDir/$SourceList" -type f -newer "$stamp" -print -quit)" ]; then
        NEED_UPDATE_CHECK=yes
    fi
else
    if [ "$(find "/$StateDir/$ListDir" "/$EtcDir/$SourceList" -type f -print -quit)" ]; then
        NEED_UPDATE_CHECK=yes
    fi
fi

# output something for update-motd
if [ -n "$NEED_UPDATE_CHECK" ]; then
    {
        echo ""
        /usr/lib/update-notifier/apt-check --human-readable
        echo ""
    } > $stamp
fi

# output what we have (either cached or newly generated)


echo "$stamp"
