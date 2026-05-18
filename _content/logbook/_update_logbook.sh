#! /bin/bash 

# - Creates logbook pages from new gpx tracks
# - Moves gpx to assets

for f in *.gpx
do
    filename="$f"
    post_filename="../../_posts/logbook/`basename -s .gpx $(echo "$f"| tr ' •' '-')`.md"    
    
    template="---
title: ${filename%.*}
gpx_filename: $f
thumbnail: 
---
"
    echo "$template" > $post_filename
    mv -n "$f" "../../assets/tracks/logbook/$f"
done