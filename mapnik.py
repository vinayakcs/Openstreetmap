import mapnik,os
m=mapnik.Map(600,400)
style= '/var/www/mapnik.xml'
mapnik.load_map(m,style)
m.zoom_all()
mapnik.render_to_file(m,'map.png')
