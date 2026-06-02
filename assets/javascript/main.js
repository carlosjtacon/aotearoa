function stringToColour(str) {
	if (!str) {
		// Default color
		return '#CF0D0D'
	}
	// https://stackoverflow.com/questions/3426404/create-a-hexadecimal-colour-based-on-a-string-with-javascript
	let hash = 0;
	str.split('').forEach((char) => {
		hash = char.charCodeAt(0) + ((hash << 5) - hash)
	})
	let colour = '#'
	for (let i = 0; i < 3; i++) {
		const value = (hash >> (i * 8)) & 0xff
		colour += value.toString(16).padStart(2, '0')
	}
	return colour
}

function coordinatesDistance(lat1, lon1, lat2, lon2) {
		// https://www.movable-type.co.uk/scripts/latlong.html
		const R = 6371e3; // metres
		const φ1 = lat1 * Math.PI/180; // φ, λ in radians
		const φ2 = lat2 * Math.PI/180;
		const Δφ = (lat2-lat1) * Math.PI/180;
		const Δλ = (lon2-lon1) * Math.PI/180;
		
		const a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
				Math.cos(φ1) * Math.cos(φ2) *
				Math.sin(Δλ/2) * Math.sin(Δλ/2);
		const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
		
		const d = R * c; // in metres
		return d;
	}