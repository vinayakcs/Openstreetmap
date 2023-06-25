
# Opensource mapserver 
Map server will fetch openstreetmap data from local postgis database and
renders map on client.   
The rendered map will need to be cached for faster response.   

### Reference links  
   - [Maptools.org](http://maptools.org/)
   - [Switch2OSM](https://switch2osm.org/)
   - [Geoserver and OpenStreetMap](http://blog.geoserver.org/2009/01/30/geoserver-and-openstreetmap/)
   - [WMS Tutorial](http://giscollective.org/tutorials/web-mapping/wmsseven/)
   - [Beginner's Guide to Building a Map Server](http://www.axismaps.com/blog/2012/01/dont-panic-an-absolute-beginners-guide-to-building-a-map-server/)
   - [Build Your Own OpenStreetMap Server](http://weait.com/content/build-your-own-openstreetmap-server)
   - [Take Control of Your Maps](http://alistapart.com/article/takecontrolofyourmaps)
   - [OSM Web Tutorial](http://www.emacsen.net/osm/osm-web-tutorial.pdf)
 
  
### OSM data 
Get osm.pbf or osm.bz2 file from [download.geofabrik.de](download.geofabrik.de). typically 300MB file.Check malta it has the smallest size.  
### Prerequisite Installation
1. `sudo apt-get install python-software-properties`
2. `sudo add-apt-repository ppa:mapnik/boost`
3. `sudo apt-get update`
4. `sudo apt-get install libboost-dev libboost-filesystem-dev libboost-program-options-dev libboost-python-dev libboost-regex-dev libboost-system-dev libboost-thread-dev`
5. `sudo apt-get install subversion git-core tar unzip wget bzip2 build-essential autoconf libtool libxml2-dev libgeos-dev libpq-dev libbz2-dev proj munin-node munin libprotobuf-c0-dev protobuf-c-compiler libfreetype6-dev libpng12-dev libtiff4-dev libicu-dev libgdal-dev libcairo-dev libcairomm-1.0-dev apache2 apache2-dev libagg-dev liblua5.2-dev ttf-unifont`


### DB Setup
1. Here postgres-9.1 is used, you can use another version
2. Install postgres: `sudo apt-get install postgresql-9.1 postgresql-contrib-9.1 postgresql-9.1-postgis`
3. Create "travelbaba" super user: `sudo -u postgres createuser -s travelbaba`
4. Create database with name "gis": `sudo -u postgres createdb -O travelbaba gis`
5. Alter user travelbaba with password 'travelbaba': `alter user travelbaba with password 'travelbaba';`
6. Enable hstore extensions: `psql -d gis -c 'create extension hstore;'`
7. Enable postgis extension. If `psql -d gis -c 'create extension postgis;'` doesn't work, try the following commands:
   - (a) `psql -d gis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql`
   - (b) `psql -d gis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql`
   - (c) `psql -d gis -c 'grant all on geometry columns to public'`
   - (d) `psql -d gis -c 'grant all on spatial_ref_sys to public'`
   - (e) `psql -d gis -c 'grant all on geography columns to public'`


### Installing osm2pgsql
1. `git clone https://github.com/openstreetmap/osm2pgsql`
2. `./autogen.sh`
3. `./configure`
4. `make`
5. `sudo make install`
6. `psql -f /usr/local/share/osm2pgsql/900913.sql -d gis`

### Dumping data to gis
`osm2pgsql –create –slim –cache 1000 –hstore –style /usr/share/osm2pgsql/default.style
–multi-geometry ’/home/crusaderwolf/Desktop/india-latest.osm.pbf’ –number-
processes 4`  

Installing map renderer-mapnik
1. `sudo add-apt-repository ppa:mapnik/nightly-2.0`
2. `sudo apt-get update`
3. `sudo apt-get install libmapnik mapnik-utils python-mapnik`

Installing Tilestache, for caching
1. `sudo apt-get install libapache2-mod-python && sudo /etc/init.d/apache2 restart`
2. `cd /etc`
3. `sudo apt-get install curl git-core python-setuptools python-dev libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev`
4. `sudo curl -O https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py`
5. `sudo pip install -U werkzeug`
6. `sudo pip install -U simplejson`
7. `sudo pip install -U modestmaps`
8. `sudo pip install -U pil`
9. `sudo git clone https://github.com/migurski/TileStache.git`
10. `cd TileStache/`
11. `sudo python setup.py install`
12. Edit `/etc/apache2/httpd.conf` and add the following configuration:
```
<Directory /var/www/tiles>
AddHandler mod_python .py
PythonHandler TileStache::modpythonHandler
PythonOption config /etc/TileStache/tilestache.cfg
</Directory>
```

### Check TileStache is installed
Go to [http://127.0.1.1/tiles/tiles.py/osm/preview.html](http://127.0.1.1/tiles/tiles.py/osm/preview.html) to render a map.
In case it's not working, check the error logs of Apache2.

Some plausible fixes:
1. `sudo apt-get install libjpeg-dev libjpeg8-dev`
2. `sudo ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib`
3. `sudo ln -s /usr/lib/x86_64-linux-gnu/libfreetype.so /usr/lib`
4. `sudo ln -s /usr/lib/x86_64-linux-gnu/libz.so /usr/lib`
5. `sudo pip uninstall pil`
6. `sudo pip install pil`
7. Also, try `sudo apt-get install python-imaging`

### Configure TileStache to use Mapnik
In `/etc/TileStache`, edit `tilestache.cfg` and modify the following configuration:
```
"provider": {
  "name": "mapnik",
  "mapfile": "path/to/mapnik.xml"
}

```
Replace `path/to/mapnik.xml` with the actual path to your `mapnik.xml` file.   


### start services
sudo service postgresql restart   
sudo service apache2 restart   
Then go to http://127.0.1.1/tiles/tiles.py/example/preview.html#5/12.971/77.594   

### Author
Vinayak srinivas [Linkedin](https://linkedin.com/in/vinayakcs)

### License
Creative Commons Attribution (CC BY)
