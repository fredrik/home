#!/bin/sh

# run this every sunday night, plox

author="Roboto <bob@slacker.se>"
days="monday tuesday wednesday thursday friday saturday sunday"

cd ~/Desktop/pda

# force changes to be saved
git add days

# move to archive.
year=`date +"%Y"`
week=`date +"%W"`
week='04'
weekly_archive=archive/$year/week-$week

mkdir $weekly_archive

git mv "week-$week" $weekly_archive
for day in $days; do
    git mv days/$day $weekly_archive/$day
done

# create empty files for the coming week
for day in $days; do
    echo > days/$day;
done
git add days

git commit --author "$author" -m 'weekly refresh.' .
