# IDG110 Grunnleggende web practical exam

> Author: Jenny Ngo Luong

## The project comprises of the following components, each developed independently from the other
### 1. The scraping script (scraper.sh)
Web scraper using `curl` to extract news article by processing the HTML page. This script fetches the first three current news from `www.tv2.no/nyheter/`, `www.nrk.no/innlandet/`, `www.tv2.no/sport/` every 6 hours and saves the information on each article with 5 lines:
1. The URL of the news article
2. The title of the news article
3. The URL of the main image found inside the webpage for the news article
4. The date when the article has been scraped
5. A summary of the news article

### 2. The pages script (pages.sh)
The pages script reads all the information stored in the files created by the scraping script and then creates a series of HTML pages, one for each news article.
The HTML page has the following items:
- Title of the news article
- Image associated to the news article
- Summary of the news article
- Date in which it has been scraped
- A link to then news article on the original webpage
- A link back to the local overview page

### 3. The overview script (overview.sh)
The overview script generates a HTML overview page, `index.html, with all the available news titles generated from the pages script sorted by date (the most recent is being displayed first).

### 4. Repo update script (repo.sh)
The repo update script commits all the new and changed files to the local git repository then pushes it to a centralized repository set by the user running the deployment script. This script can be run unattended when launched by cron given that the user has set up git credentials correctly.

### 5. The nginx configuration file
In order to serve the generated HTML files, a Nginx server has to be properly set up. The followed nginx configuration file follows the Debian/Ubuntu conventions and is automatically set up and copied over to the system when running the deployment script.

### 6. The crontab entries script (crontab.sh)
The news website has to be scraped every 6 hours, and to achieve this crontab is used. This script sets up the 2 cron jobs for just that (the first one for scraping and the second for update repo). This script will only work if the user has successfully setup git and added the remote repository link at `/var/www/html/`.

### 7. The deployment script (deployment.sh)
The deployment script configures a blank installation with all that is necessary for the project to work. Things it'll take care of are the following:
- Installing dependencies
- Fetches the git repository from GitHub
- Placing all scripts in the right directory
- Generating all directories needed for the script to work properly
- Copying the nginx configuration file for the website and enabling it
- Setting up the crontab

## Getting started
1. After configuring the raspberry PI, clone the project repository and navigate to the project file:
```sh
$ git clone git@github.com:Jendeuk/idg1100-practical-exam.git
$ cd idg1100
```
2. Run the deployment script with:
```sh
$ chmod +x deployment.sh
$ ./deployment.sh
```
3. (Optional) For the repo to work, setup a local repository at `/var/www/html/` and link it to a remote by:
```sh
$ cd /var/www/html
$ git init
$ git remote add origin <remote repository link here>
$ git add .
$ git commit -m "first commit"
$ git branch -M main
$ git push -u origin main
```
- Note: the ssh key used for the git user shouldn't have a password either for this to work

## Features implemented
All the main features are implemented as expected, further some other optional features are also implemented such as:
> - [x] 🌟 Also reads from https://www.nrk.no/innlandet/ or https://www.mn24.no/nyheter/
> - [x] 🌟 On days with even numbers read news from https://www.tv2.no/sport/ 
> - [x] 🌟🌟 Also retrieve a summary of each news article and add it as a fifth line in the information files. 
> - [x] 🌟 Sort the news articles by date, with the most recent first 
> - [x] 🌟🌟 The repo update script pushes all new files and the updated files to a GitHub repository.  
> - [x] 🌟 The deployment script configures a blank installation of Raspberry Pi OS with all that is necessary for the project to work.

