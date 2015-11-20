
SHAPEFILE_URL         = http://download.geofabrik.de/europe/ireland-and-northern-ireland-latest.shp.zip
SHAPEFILE_OUTPUT_FILE = tmp/ireland.shp.zip
RPLOTS_PDF            = Rplots.pdf
SHAPEFILE_FOLDER      = tmp/ireland
SHAPEFILE_ROAD_PATH   = $(SHAPEFILE_FOLDER)/roads.shp

CLI                   = src/R/plot-map.R

SOFTEN_INVERT_MAP     = soften-invert-map.scm
SOFTEN_CONTRAST_MAP   = soften-contrast-map.scm

IMAGE_OUTPUT          = images/irish-map-raw.png
DARK_IMAGE_OUTPUT     = images/irish-map-dark.png
LIGHT_IMAGE_OUTPUT    = images/irish-map-light.png

COORD_PATH            = data/irish-tweets.txt

WIDTH                 = 2500




build: post-process

create-dirs:
	-mkdir -p tmp
	-mkdir -p tmp/ireland
	-mkdir -p images

$(SHAPEFILE_OUTPUT_FILE): create-dirs
	wget "$(SHAPEFILE_URL)" --output-document="$(SHAPEFILE_OUTPUT_FILE)"

unzip-shapefile:
	unzip $(SHAPEFILE_OUTPUT_FILE) -d $(SHAPEFILE_FOLDER)





render: unzip-shapefile

	Rscript $(CLI) --streetpath $(SHAPEFILE_ROAD_PATH) --coordpath $(COORD_PATH) --outfile $(IMAGE_OUTPUT) --dimension $(WIDTH)





post-process: render post-process-dark-image post-process-light-image

post-process-dark-image:

	cp $(IMAGE_OUTPUT) $(DARK_IMAGE_OUTPUT)

	cat src/scheme/$(SOFTEN_INVERT_MAP) > ~/.gimp-2.8/scripts/$(SOFTEN_INVERT_MAP)
	gimp -ib '(cli-soften-invert-map "$(DARK_IMAGE_OUTPUT)")' -b '(gimp-quit 0)'

post-process-light-image:

	cp $(IMAGE_OUTPUT) $(LIGHT_IMAGE_OUTPUT)

	cat src/scheme/$(SOFTEN_CONTRAST_MAP) > ~/.gimp-2.8/scripts/$(SOFTEN_CONTRAST_MAP)
	gimp -ib '(cli-soften-contrast-map "$(LIGHT_IMAGE_OUTPUT)")' -b '(gimp-quit 0)'





clean:
	-rm $(RPLOTS_PDF) $(SHAPEFILE_OUTPUT_FILE)
	-rm -rf tmp

.PHONY: build create-dirs unzip-shapefile post-process clean
