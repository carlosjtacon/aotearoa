#! /bin/bash 
# requires imagemagick installed - brew install imagemagick
# requires exiftool installed - brew install exiftool

# - Creates thumbnails
# - Renames photos to add date
# - Creates photo pages with exif frontmatter

THUMB_MAX=1024

for f in *.jpeg
do
    filename="$f"
    filename_dated=$(exiftool -d "%Y%m%d_%H%M%S" -CreateDate "$f" | awk '{print $4}')_$f
    exif=$(exiftool "$f" -S -Title -FileSize -Software -UserComment -ImageWidth -ImageHeight -Make -Model -LensInfo -ExposureTime -ISO -ExposureCompensation -Flash -Keywords -DateTimeOriginal -d "%Y-%m-%d %H:%M:%S")
    exif_gps=$(exiftool "$f" -S -GPSAltitude -GPSLatitude -GPSLatitudeRef -GPSLongitude -GPSLongitudeRef -c "%.6f" -n)
    photo_post_path="../../_photos/${filename_dated%.*}.md"
    template="---
File: ${filename_dated}
Title: ${filename%.*}
${exif}
${exif_gps}
---
"
    echo "${filename}"
    # Create the photo post with exif metadata
    echo "$template" > "${photo_post_path}"
    # Create thumbnails
    thumbpath="../../assets/photos/thumbs/${filename_dated%.*}-thumb.webp"
    magick "$f" -thumbnail "${THUMB_MAX}>" "${thumbpath}"
    # Move the photo to the assets folder
    mv -n "$f" "../../assets/photos/$filename_dated"
done