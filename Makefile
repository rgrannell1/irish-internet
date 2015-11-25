
SHAPEFILE_URL            = http://download.geofabrik.de/europe/ireland-and-northern-ireland-latest.shp.zip
SHAPEFILE_OUTPUT_FILE    = tmp/ireland.shp.zip
RPLOTS_PDF               = Rplots.pdf
SHAPEFILE_FOLDER         = tmp/ireland
SHAPEFILE_ROAD_PATH      = $(SHAPEFILE_FOLDER)/roads.shp

CLI                      = src/R/plot-map.R

SOFTEN_INVERT_MAP        = soften-invert-map.scm
SOFTEN_CONTRAST_MAP      = soften-contrast-map.scm

RAW_IRELAND_IMAGE_OUTPUT = images/irish-map-raw.png
RAW_GALWAY_IMAGE_OUTPUT  = images/galway-map-raw.png
RAW_DUBLIN_IMAGE_OUTPUT  = images/dublin-map-raw.png

COORD_PATH               = data/irish-tweets.txt

IRELAND_SCALE            = 750
GALWAY_SCALE             = 2000
DUBLIN_SCALE             = 2000




# -- Script: $1, Cmd: $2, Source: $3, Name: $4
define run-gimp-script

	cp $(3) images/$(4).png

	cat src/scheme/$(1) > ~/.gimp-2.8/scripts/$(1)
	gimp -ib '($(2) "images/$(4).png")' -b '(gimp-quit 0)'

endef

# -- Dimension: $1
define draw-map
	Rscript $(CLI) --streetpath $(SHAPEFILE_ROAD_PATH) --coordpath $(COORD_PATH) --outfile $(2) --scale $(1)
endef

# -- Dimension: $1, X0: $2, X1: $3, Y0: $4, Y1: $5,
define draw-map-within-border

	Rscript $(CLI) --streetpath $(SHAPEFILE_ROAD_PATH) --coordpath $(COORD_PATH) --outfile $(6) --scale $(1) \
		--longitude=$(2),$(3) --latitude=$(4),$(5)

endef





all: post-process

create-dirs:
	-mkdir -p tmp
	-mkdir -p tmp/ireland
	-mkdir -p images

$(SHAPEFILE_OUTPUT_FILE): create-dirs
	wget "$(SHAPEFILE_URL)" --output-document="$(SHAPEFILE_OUTPUT_FILE)"

unzip-shapefile:
	unzip -o $(SHAPEFILE_OUTPUT_FILE) -d $(SHAPEFILE_FOLDER)





render: unzip-shapefile render-ireland render-galway render-dublin

render-ireland:
	$(call draw-map,$(IRELAND_SCALE),$(RAW_IRELAND_IMAGE_OUTPUT))

render-galway:
	$(call draw-map-within-border,$(GALWAY_SCALE),-9.6,-8.6,53,53.5,$(RAW_GALWAY_IMAGE_OUTPUT))

render-dublin:
	$(call draw-map-within-border,$(DUBLIN_SCALE),-7,-6,53,53.5,$(RAW_DUBLIN_IMAGE_OUTPUT))





post-process: render post-process-dark-image post-process-light-image

post-process-dark-image: post-process-ireland-dark-image post-process-galway-dark-image post-process-dublin-dark-image

post-process-ireland-dark-image:
	$(call run-gimp-script,$(SOFTEN_INVERT_MAP),cli-soften-invert-map,$(RAW_IRELAND_IMAGE_OUTPUT),irish-map-dark)

post-process-galway-dark-image:
	$(call run-gimp-script,$(SOFTEN_INVERT_MAP),cli-soften-invert-map,$(RAW_GALWAY_IMAGE_OUTPUT),galway-map-dark)

post-process-dublin-dark-image:
	$(call run-gimp-script,$(SOFTEN_CONTRAST_MAP),cli-soften-invert-map,$(RAW_DUBLIN_IMAGE_OUTPUT),dublin-map-dark)





post-process-light-image: post-process-ireland-light-image post-process-galway-light-image post-process-dublin-light-image

post-process-ireland-light-image:
	$(call run-gimp-script,$(SOFTEN_CONTRAST_MAP),cli-soften-contrast-map,$(RAW_IRELAND_IMAGE_OUTPUT),irish-map-light)

post-process-galway-light-image:
	$(call run-gimp-script,$(SOFTEN_CONTRAST_MAP),cli-soften-contrast-map,$(RAW_GALWAY_IMAGE_OUTPUT),galway-map-light)

post-process-dublin-light-image:
	$(call run-gimp-script,$(SOFTEN_CONTRAST_MAP),cli-soften-contrast-map,$(RAW_DUBLIN_IMAGE_OUTPUT),dublin-map-light)





clean:
	-rm $(RPLOTS_PDF) $(SHAPEFILE_OUTPUT_FILE)
	-rm -rf tmp

.PHONY: all create-dirs unzip-shapefile post-process clean
