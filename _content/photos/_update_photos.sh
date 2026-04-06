#! /bin/bash 
# requires imagemagick installed - brew install imagemagick
# requires exiftool installed - brew install exiftool

# - Creates thumbnails
# - Renames photos to add date
# - Creates photo pages with exif frontmatter

THUMB_MAX=1024
for i in $1/*.jpeg
do
    filename=`basename -s .jpeg $i`
    [ ! -f "$1/$filename-thumb.webp" ] && magick "$i" -thumbnail "${THUMB_MAX}>" "$1/$filename-thumb.webp"
done

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