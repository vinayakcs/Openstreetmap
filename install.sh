#!/bin/bash
apt-get update  
sudo add-apt-repository ppa:mapnik/nightly-2.0
sudo apt-get update

apt-get install python-software-properties install libboost-dev libboost-filesystem-dev libboost-program-options-dev libboost-python-dev libboost-regex-dev libboost-system-dev libboost-thread-dev subversion git-core tar unzip wget bzip2 build-essential autoconf libtool libxml2-dev libgeos-dev libpq-dev libbz2-dev proj munin-node munin libprotobuf-c0-dev protobuf-c-compiler libfreetype6-dev libpng12-dev libtiff4-dev libicu-dev libgdal-dev libcairo-dev libcairomm-1.0-dev apache2 apache2-dev libagg-dev liblua5.2-dev ttf-unifont 
#db
apt-get postgresql-9.1 postgresql-contrib-9.1 postgresql-9.1-postgis osm2pgsql 
#mapnik
apt-get libmapnik mapnik-utils python-mapnik libapache2-mod-python curl 
#tilstache
apt-get git-core python-setuptools python-dev libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev libjpeg-dev libjpeg8-dev python-imaging

sudo ln -s /usr/lib/x86 64-linux-gnu/libjpeg.so /usr/lib
sudo ln -s /usr/lib/x86 64-linux-gnu/libfreetype.so /usr/lib
sudo ln -s /usr/lib/x86 64-linux-gnu/libz.so /usr/lib

sudo -u postgres createuser -s gisuser
sudo -u postgres createdb -O gisuser gis
sudo -u postgres psql -c "ALTER USER gisuser WITH PASSWORD 'gispwd';"
sudo -u postgres psql -d gis -c "CREATE EXTENSION if not exists hstore;"
sudo -u postgres psql -d gis -c "CREATE EXTENSION if not exists postgis;"
# try below command in case extension postgis did notwork
#psql -d gis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql
#psql -d gis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial ref sys.sql
#psql -d gis -c ’grant all on geometry columns to public’
#psql -d gis -c ’grant all on spatial ref sys to public’
#psql -d gis -c ’grant all on geography columns to public’

PG_HBA_FILE="/etc/postgresql/9.1/main/pg_hba.conf"
# Backup the original pg_hba.conf file
sudo cp "$PG_HBA_FILE" "${PG_HBA_FILE}.bak"
# Edit pg_hba.conf file to replace "local all all peer" with "local all all md5"
sudo sed -i 's/local\s\+all\s\+all\s\+peer/local all all md5/' "$PG_HBA_FILE"


# Download get-pip.py script
sudo curl -O https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py && pip install -U werkzeug && pip install -U simplejson && pip install -U modestmaps && pip install -U pil
