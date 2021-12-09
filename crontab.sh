#!/usr/bin/env bash

# Crontab script 
(crontab -l 2>/dev/null; echo "* * * * * echo \`date\` > /var/www/html/scraper.sh") | crontab -

