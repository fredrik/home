#!/bin/sh

# run this every sunday night, plox

days="mandag.txt tisdag.txt onsdag.txt torsdag.txt fredag.txt"
tag=`date +"%y%m%d"`
author="Roboto <bob@slacker.se>"

cd ~/Desktop

# force changes to be saved
git add $days

# move to archive.
mkdir days
for day in $days; do
	git mv $day days/$tag-$day
done

git commit --author "$author" -m 'weekly purge.' days


# create empty files for the coming week
for day in $days; do
	echo > $day;
done
git add $days
git commit --author "$author" -m 'adding weekly files.' $days

