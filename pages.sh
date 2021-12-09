#!/usr/bin/env bash

# Pages script
date="$1"
scrapedir="scraped-news"
rootdir="pages"
dir="news-$date"
mkdir -p "$rootdir/$dir"
echo "[*] CREATING PAGES"
dirname=`dirname "$0"`
cd $dirname

# Fetches the current first three news articles
numpages=`ls -1 $scrapedir/$dir | wc -l`
for ((i=1; i<="$numpages"; i++))
do
	file="$scrapedir/$dir/news$i.txt"
	# Title of the news article
	title=`sed -n 2p $file`
	# Image associated to then news article
	imgUrl=`sed -n 3p $file`
	# The date in which it has been scraped
	fetchDate=`sed -n 4p $file`
	# A link to the news article on the original webpage
	linkUrl=`sed -n 1p $file`
	# A link to the local overview page
	overviewUrl="../../index.html"
	# Summary text
	summary=`sed -n 5p $file`
	htmlFile="$rootdir/$dir/news$i.html"

	# Article taken from:
	newsUrl=`echo $linkUrl | grep -Eo 'https://.*.no/' | sed "s/https:\/\///" | head -c -2`
	touch $htmlFile
	echo "
	<!DOCTYPE html> 
	<html lang=\"no\"> 
	<head> 
		<meta charset=\"UTF-8\">
		<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
		<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
		<title>$title</title>
	</head> 
	<body> 
		<h1>$title</h1> 
		<div><img src=\"$imgUrl\"/></div> 
		<p>$summary</p> 
		<p>Fetched on $fetchDate <a href=\"$linkUrl\">Original article at $newsUrl</a></p> 
		<p><a href=\"$overviewUrl\">List of all available news items.</a></p>
	</body>
	</html>
	" > $htmlFile
done
# Run overview script
./overview.sh
