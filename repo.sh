#!/usr/bin/env bash

# Repo update script
dirname=`dirname "$0"`
cd $dirname

# Update repo if repository is correctly setup
if [ -d ".git" ]
then
	git add .
	git commit -m "cron update"
	git push -u origin main
fi
