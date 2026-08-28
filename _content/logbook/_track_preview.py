import sys, math, os, pathlib
import xml.etree.ElementTree as ET

# USAGE python _simplify_track.py /path/to/file.gpx [distance_threshold]

ET.register_namespace("", "http://www.topografix.com/GPX/1/1")
ET.register_namespace("osmand", "https://osmand.net/docs/technical/osmand-file-formats/osmand-gpx")
ET.register_namespace("gpxtpx", "https://www8.garmin.com/xmlschemas/TrackPointExtensionv1.xsd")
ET.register_namespace("xsi", "http://www.w3.org/2001/XMLSchema-instance")

def haversine(coord1, coord2):
  # https://janakiev.com/blog/gps-points-distance-python/

  R = 6372800  # Earth radius in meters
  lat1, lon1 = coord1
  lat2, lon2 = coord2

  phi1, phi2 = math.radians(lat1), math.radians(lat2)
  dphi       = math.radians(lat2 - lat1)
  dlambda    = math.radians(lon2 - lon1)

  a = math.sin(dphi/2)**2 + \
      math.cos(phi1)*math.cos(phi2)*math.sin(dlambda/2)**2

  return 2*R*math.atan2(math.sqrt(a), math.sqrt(1 - a))

def getTag(tag):
  return '{http://www.topografix.com/GPX/1/1}' + tag

def coordsFromTrkpt(trkpt):
  return (float(trkpt.attrib.get('lat')), float(trkpt.attrib.get('lon')))

def main():
  # DISTANCE BETWEEN POINTS TO KEEP IN METERS
  DIST_THRESHOLD = 100
  if len(sys.argv) > 2: DIST_THRESHOLD = int(sys.argv[2])
  print('Using a distace threshold of', DIST_THRESHOLD, 'meters')

  originalSize = str(int(os.path.getsize(sys.argv[1])/100000)/10) + 'MB'
  tree = ET.parse(sys.argv[1])
  root = tree.getroot()

  # remove osmand rte element
  if root.find(getTag('rte')) is not None:
   root.remove(root.find(getTag('rte')))

  for trk in root.iter(getTag('trk')):
    for trkseg in trk.iter(getTag('trkseg')):
      prevPoint = None
      removedPoints = 0
      totalPoints = len(trkseg.findall(getTag('trkpt')))
      for trkpt in trkseg.findall(getTag('trkpt')):
        coord = coordsFromTrkpt(trkpt)

        if prevPoint is None:
          prevPoint = trkpt
          continue

        prevCoord = coordsFromTrkpt(prevPoint)
        dist = haversine(coord, prevCoord)
        if dist < DIST_THRESHOLD:
          removedPoints+=1
          trkseg.remove(trkpt)
        else:
          prevPoint = trkpt

      percent = str(int(removedPoints/totalPoints*100))+ '%'
      print('Removed', percent, '-', removedPoints, 'out of', totalPoints, 'points.')

  # answer = input("Overwrite the gpx? [y/n] \n")
  # if answer.lower() in ["y","yes"]:
  filePath = pathlib.Path(sys.argv[1])
  newFile = filePath.parent / 'preview' / filePath.name
  tree.write(newFile.__str__())

  newSize = str(int(os.path.getsize(newFile.__str__())/100000)/10) + 'MB'
  print('New GPX created at', sys.argv[1])
  print('Went from', originalSize, 'to', newSize)

main()
