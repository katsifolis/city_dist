import os
import json
import cli { Command, Flag }
import math

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
	mut w := os.create('cities.json') or {
		panic('Cannot open or create file')
		return -1
	}
	w.write('[ ')
	for city in f {
		c := city.split('\t')
		country := c[8].str()
		name := c[1].str().replace('"', '').replace('"', '') // Asciiname
		lat := c[4].str()
		lon := c[5].str()
		b := '{ "country" : "$country", "name": "$name", "lat" : "$lat", "lon" : "$lon" },'
		w.write(b)
	}
	w.write(']')
	w.close()
	return 0
}

fn deg2rad(deg f64) f64 {
	return deg * (math.pi / 180)
}

// calculate_distance follows the Haversine Formula
fn calculate_distance(lat1, lon1, lat2, lon2 f64) int {

	r := 6371 // Radius of earth in km
	d_lat := deg2rad(lat2-lat1)  // deg2rad below
	d_lon := deg2rad(lon2-lon1) 
	a := math.sin(d_lat/2) * math.sin(d_lat/2) + math.cos(deg2rad(lat1)) * math.cos(deg2rad(lat2)) * math.sin(d_lon/2) * math.sin(d_lon/2)

	c := 2 * math.atan2(math.sqrt(a), math.sqrt(1-a)) 
	d := r * c // Distance in km

	return int(d)

}


fn main() {

	if os.args.len != 3 {
		println('usage: distance town1 town2')
		return
	}

	f := os.read_file('./co.json') or {
		panic(err)
		return
	}

	cities := json.decode([]City, f) or {
		panic(err)
		return
	}


	mut lat1, mut lon1, mut lat2, mut lon2 := f64(0), f64(0), f64(0), f64(0)
	mut flag, mut flag1 := true, true
	from, to :=  os.args[1], os.args[2]
	for city in cities {
		if from.capitalize() == city.name && flag == true {
			lat1 = city.lat.f64()
			lon1 = city.lon.f64()
//			println("city 1")
//			println(lat1)
//			println(lon1)
//			println("")
			flag = false
			
		}
		if to.capitalize() == city.name && flag1 == true{
			lat2 = city.lat.f64()
			lon2 = city.lon.f64()
//			println("city 2")
//			println(lat2)
//			println(lon2)
//			println("")
			flag1 = false
		}

		if flag == false && flag1 == false {
			break
		}
	}

	d := calculate_distance(lat1, lon1, lat2, lon2)

	print("Distance between $from -> $to is $d km \n")

	// This is for reading the files and constructing the json file
	//_ := read_cities(flname)
	//println('Loading cities ..')
}
