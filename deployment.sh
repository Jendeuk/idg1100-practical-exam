# Installing dependencies
sudo apt-get update && sudo apt-get upgrade
## Installing git
sudo apt-get install git
## Installing and starting nginx
sudo apt-get install nginx
sudo systemctl start nginx

# Fetches the git repository from GitHub
#git clone git@github.com:Jendeuk/idg1100-practical-exam.git
#cd idg1100-practical-exam

# Placing all scripts in the right directory
sudo cp scraper.sh /var/www/html/
sudo cp pages.sh /var/www/html/
sudo cp overview.sh /var/www/html/

# Generating all directories needed for the script to work properly
sudo mkdir -p /var/www/scraped-news
sudo mkdir -p /var/www/pages

# Copying the nginx configuration file for the website and enabling it
sudo cp ./nginx/sites-available/server /etc/nginx/sites-available/server
sudo ln -sf /etc/nginx/sites-available/server /etc/nginx/sites-enabled/server

# Setting up the crontab
./crontab.sh
