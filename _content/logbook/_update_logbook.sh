#! /bin/bash 

# - Creates logbook pages from new gpx tracks

for i in $1/$2*.jpeg
do
    photo_basename=`basename -s .jpeg $i`
    template="---
camera: $1
photo_filename: ${photo_basename}
---

<!-- English. -->

<!-- Español. -->
"
    last_post_number=$(( $last_post_number + 1))
    filename=$(printf %04d $last_post_number).md
    echo "$template" > $photos_dir$filename
done