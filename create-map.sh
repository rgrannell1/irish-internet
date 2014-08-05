#!/bin/sh

# download the latest shapefile for ireland.
wget "http://download.geofabrik.de/europe/ireland-and-northern-ireland-latest.shp.zip" --output-document='ireland.shp.zip'
unzip ireland.shp.zip -d ireland

# plot the raw data in R.
Rscript plot-map.R

# post-process in gimp.
cat soften-invert-map.scm > ~/.gimp-2.8/scripts/soften-invert-map.scm
gimp -i -b '(cli-soften "irish-map.png")' -b '(gimp-quit 0)'

rm Rplots.pdf