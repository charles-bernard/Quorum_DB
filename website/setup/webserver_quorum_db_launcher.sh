#!/bin/bash

# Put the following line in your bashrc
# alias quorum_db_serv='REPO_PATH/website/setup/webserver_quorum_db_launcher.sh'

# Then give the right to the user to execute this script
# sudo chmod u+x REPO_PATH/website/setup/webserver_quorum_db_launcher.sh

# This script accepts argument start | stop | restart

if [ "$1" != "" ]; then
   cmd="sudo service apache2 $1; sudo service postgresql $1"
   eval $cmd
else
   echo "No option was provided"
fi
