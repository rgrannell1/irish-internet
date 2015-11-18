
SHAPEFILE_URL         = http://download.geofabrik.de/europe/ireland-and-northern-ireland-latest.shp.zip
SHAPEFILE_OUTPUT_FILE = tmp/ireland.shp.zip
RPLOTS_PDF            = Rplots.pdf
SHAPEFILE_FOLDER      = tmp/ireland
SHAPEFILE_ROAD_PATH   = $(SHAPEFILE_FOLDER)/roads.shp

CLI                   = src/R/plot-map.R
SCHEME_NAME           = soften-invert-map.scm
SCHEME_FILE           = src/scheme/$(SCHEME_NAME)

IMAGE_OUTPUT          = images/irish-map.png
COORD_PATH            = data/irish-tweets.txt

WIDTH                 = 2500




build: post-process

create-dirs:
	-mkdir -p tmp
	-mkdir -p tmp/ireland
	-mkdir -p images

$(SHAPEFILE_OUTPUT_FILE): create-dirs
	wget "$(SHAPEFILE_URL)" --output-document="$(SHAPEFILE_OUTPUT_FILE)"

unzip-shapefile: $(SHAPEFILE_OUTPUT_FILE)
	unzip $(SHAPEFILE_OUTPUT_FILE) -d $(SHAPEFILE_FOLDER)

render: unzip-shapefile
	Rscript $(CLI) --streetpath $(SHAPEFILE_ROAD_PATH) --coordpath $(COORD_PATH) --outfile $(IMAGE_OUTPUT) --dimension $(WIDTH)

post-process: render
	cat $(SCHEME_FILE) > ~/.gimp-2.8/scripts/$(SCHEME_NAME)
	gimp -ib '(cli-soften "$(IMAGE_OUTPUT)")' -b '(gimp-quit 0)'





clean:
	-rm $(RPLOTS_PDF) $(SHAPEFILE_OUTPUT_FILE)
	-rm -rf tmp

.PHONY: build create-dirs unzip-shapefile post-process clean
