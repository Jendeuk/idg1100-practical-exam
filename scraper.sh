#!/usr/bin/env bash

# Scraping script
# Get current date
date=`date +%Y-%m-%d-%H%M`
datetime=`date "+%Y-%m-%d %H:%M"`
echo "[*] SCRAPING"
echo $date

# Create a new directory storing the information about the news articles
rootdir="scraped-news"
dir="$rootdir/news-$date"
mkdir -p "$dir"

i=1
declare -a urls=("https://www.tv2.no/nyheter" "https://www.nrk.no/innlandet/" "https://www.tv2.no/sport")
# Fetches the current first three news articles for each of the urls declared above 
for ((index=0; index < "${#urls[@]}"; index++))
do
	# Set url and fetch articles from that url
	url="${urls[$index]}"
	echo $url
	if [ "$url" = "https://www.tv2.no/nyheter" ]
	then
		news=`curl -s $url | grep -E "class=\"article__link\"" | cut -d "=" -f 3 | sed 's/">//g' | sed 's/"/https:\/\/www.tv2.no/g' | head -3`
	elif [ "$url" = "https://www.nrk.no/innlandet/" ]
	then
		news=`curl -s $url | grep -E -A 1 "class=\"article widget" | grep -Eo "href=\".*\"" | cut -d" " -f 1 | sed "s/href=\"//g" | sed "s/.$//g" | head -3`
	else
		news=`curl -s $url | grep -E "class=\"article__link\"" | cut -d "=" -f 3 | sed 's/">//g' | sed -n -e "/\"\//p" | sed 's/"/https:\/\/www.tv2.no/g' | head -3`

		# Check if days are even to read from www.tv2.no/sport, skip of not
		if [ $((`date +%-d`%2)) -ne 0 ]
		then
			continue
		fi
	fi

	# For each news article, create and information file with 4 lines
	for nurl in $news
	do
		# Create new information file with url
		file="$dir/news$i.txt"
		echo $nurl > $file
		# Add title of the news article
		title=`curl -s $nurl | grep -Eo "<title>.*</title>" | head -1 | sed 's/\(<title>\|<\/title>\)//g'`
		echo $title >> $file

		# Text processing method depends on which page is parsed
		if [[ "$url" == "https://www.tv2.no/nyheter" || "$url" == "https://www.tv2.no/sport" ]]
		then
			imageUrl=`curl -s $nurl | grep -E "itemprop=\"image\"" | head -1 | grep -Eo 'data-src=".*"' | cut -d" " -f 1 | sed 's/data-src="//g' | head -c -2`
			summary=`curl -s $nurl | grep -Eo "<p.*</p>" | sed "s/<[^>]*>/ /g" | tr " " "\n" | head -100 | xargs -n100`
		elif [ "$url" = "https://www.nrk.no/innlandet/" ]
		then
			#imageUrl=`curl -s $nurl | grep -E -A 1 "class=\"image widget" | head -2 | grep -Eo 'srcset=".*"' | cut -d" " -f 1 | sed "s/srcset=\"//g"`
			imageUrl=`curl -s $nurl | grep -E -A 1 "class=\"image widget" | head -2 | grep -Eo 'srcset=".*" ' | sed "s/src/\n/g" | head -2 | xargs | sed "s/, /\n/g" | sed -n 5p | cut -d" " -f 1`
			summary=`curl -s $nurl | grep -Eo "<p.*</p>" | sed "s/<[^>]*>/ /g" | tr " " "\n" | head -100 | xargs -n100`
		else
			imageUrl=""
			summary=""
		fi
		# Add URL of the main image found inside the webpage for the news article
		echo $imageUrl >> $file
		# Add the date when the article was scraped
		echo $datetime >> $file
		# Add the summary of the article
		echo "$summary..." >> $file
		echo $i
		((i++))
	done
done
# Run pages script with same date as args
./pages.sh $date
