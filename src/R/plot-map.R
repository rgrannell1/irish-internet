#!/usr/bin/env Rscript





if (!require(sp)) {
	install.packages(sp)
}

if (!require(maptools)) {
	install.packages(maptools)
}

if (!require(devtools)) {
	install.packages(devtools)
}

if (!require(docopt)) {
	library(devtools)
	install_github("docopt/docopt.R")
}


library(sp)
library(maptools)
library(docopt)





'
Usage: plot-map.R [-s X | --streetpath X] [-c X | --coordpath X] [-o X | --outfile <path>] [-d X | --scale X] [-x X | --longitude X] [-y X | --latitude X]

Options:

	-s X, --streetpath X     the location of the .shp file outline Ireland\'s streets [default: ireland/roads.shp].
	-c X, --coordpath X      the location of a line-delimited longitude/latitude coordinates [default: data/irish-tweets.txt].
	-o X, --outfile X        the location to which the render should be saved [default: irish-map.png].
	-d X, --scale X          the pixels per degree of longitude/latitude  [default: 100]

	-x X, --longitude X      the longitude boundaries to draw within [default: -11,-5]
	-y X, --latitude X       the latitude boundaries to draw within [default: 51.5,55.5]

' -> doc




calcImageDims <- list(
	width  = function (longDegrees, scale = 1) {
		scale * longDegrees
	},
	height = function (latDegrees, scale = 1) {
		2 * scale * latDegrees
	}
)



opts      <- docopt(doc)



borders   <- list(
	longitude = vapply(strsplit(opts $ longitude, ',')[[1]], as.numeric, numeric(1)),
	latitude  = vapply(strsplit(opts $ latitude,  ',')[[1]], as.numeric, numeric(1))
)


constants <- list(

	colour = list(
		blue = '#55ACEE',
		grey = '#333f4a'
	),
	graph = list(
		res = 300,
		cex = 0.06,
		pch = 15,
		lwd = 0.02
	)

)





streets     <- readShapeLines(opts $ streetpath)
coords      <- as.list(read.table(opts $ coordpath))

street_segs <- lapply(streets @ lines, function (line) {
	line @ Lines[[1]] @ coords
})

op <- par(mar = rep(0, 4))





png(
	opts $ outfile,

	width  = calcImageDims $ width(diff(borders $ longitude), as.numeric(opts $ scale)),
	height = calcImageDims $ height(diff(borders $ latitude), as.numeric(opts $ scale)),

	res = constants $ graph $ res)

	op <- par(mar = rep(0, 4))

	plot(
		coords[[2]], coords[[1]],

		xlim = borders $ longitude,
		ylim = borders $ latitude,

		col  = constants $ colour $ blue,

		cex  = constants $ graph $ cex,
		pch  = constants $ graph $ pch
	)

	invisible(lapply(street_segs, function (seg) {
		lines(seg[,1], seg[,2], col = constants $ colour $ grey, lwd = constants $ graph $ lwd)
	}) )

dev.off( )
