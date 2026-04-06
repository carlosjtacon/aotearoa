#! /bin/bash 

# - Renames walks adding date to it

for f in *.gpx
do
    echo "$f"
    mv -n "$f" "../../assets/tracks/walks/$(date -r "$f" +"%Y%m%d")_$f"
done