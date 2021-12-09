#!/usr/bin/env bash

# Overview script
echo "[*] CREATING OVERVIEW PAGE"
pagesdir="pages"

# Recursively get all files from generated pages
# By using ls -t we get the files sorted by modification time, meaning by date.
# Piping it further to tac we get the lastest/most recent files first :)
pages=`find pages -type f -exec ls -1rt "{}" + | tac`

# For each generated page article, link the local HTML page
# Create the overview index.html file
html="index.html"
touch $html
# Add first part of the html file
echo "
<!DOCTYPE html> 
<html lang=\"no\"> 
<head> 
	<meta charset=\"UTF-8\">
	<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
	<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
	<title>Overview of recent news</title>
</head> 
<body> 
	<h1>Overview of recent news</h1> 
	<ul>
" > $html
# Loop through all the generated pages and insert link
for page in $pages
do
	title=`cat $page | grep "<title>" | sed 's/\(<title>\|<\/title>\)//g' | xargs`
	echo "<li><a href=\"$page\">$title</a></li>" >> $html
done
# Add last part of the html file
echo "
	</ul>
</body>
</html>
" >> $html
