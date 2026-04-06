#! /bin/bash 

# - Renames walks adding date to it

for f in ../assets/tracks/walks/*.gpx
do
    echo "$f"
    # mv -n "$f" "$(date -r "$f" +"%Y%m%d")_$f"
done