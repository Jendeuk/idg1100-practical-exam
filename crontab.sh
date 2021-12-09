#!/usr/bin/env bash

# Crontab script 
(crontab -l 2>/dev/null; echo "0 */6 * * * /var/www/html/scraper.sh") | crontab -
(crontab -l 2>/dev/null; echo "5 */6 * * * /var/www/html/repo.sh") | crontab -

