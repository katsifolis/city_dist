import os
import json

const (
	flname = './cities5000.txt'
)

// City struct
struct City {
	country string
	name    string
	lat     string
	lon     string
}

// read_cities constructs an array of all cities containng the name, lat, lon of them
fn read_cities(file_name string) int {

	f := os.read_lines(file_name) or {
		panic(err)
	}

	mut w := os.create('co.json') or {
		panic('Cannot open or create file')
		return -1
	}


	w.write('[ ')
	
	for n, city in f {

		c := city.split('\t')
		country := c[8].str()
		name := c[1].str().replace('"', '').replace('"', '')
		lat  := c[4].str()
		lon  := c[5].str()
		b := '{ "country" : "$country", "name": "$name", "lat" : "$lat", "lon" : "$lon" },'

		w.write(b)

	}
	w.write(']')

	w.close()
	return 0
}

fn main() {
	// This is for reading the files and constructing the json file
	//	_ := read_cities(flname)
	//	println('Loading cities ..')

	f := os.read_file('./cities.json') or {
		panic("Couldn't open file")
		return
	}

	s := json.decode([]City, f) ?

}
