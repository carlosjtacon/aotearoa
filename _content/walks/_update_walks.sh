#! /bin/bash 

# - Renames and moves walks to assets adding date

for f in *.gpx
do
    # echo "$f"
    mv -n "$f" "../../assets/tracks/walks/$(date -r "$f" +"%Y%m%d")_$f"
done