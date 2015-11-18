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
Usage: plot-map.R [-s X | --streetpath X] [-c X | --coordpath X] [-o X | --outfile <path>] [-d X | --dimension X]

Options:

	-s X, --streetpath X     the location of the .shp file outline Ireland\'s streets [default: ireland/roads.shp].
	-c X, --coordpath X      the location of a line-delimited longitude/latitude coordinates [default: data/irish-tweets.txt].
	-o X, --outfile X        the location to which the render should be saved [default: irish-map.png].
	-d X, --dimension X      the default width of the image; the height is 1.317 times larger [default: 2080].

' -> doc




opts      <- docopt(doc)

constants <- list(

	colour = list(
		blue = '#55ACEE',
		grey = '#333f4a'
	),
	dimensions = list(
		width  = 1.000 * as.integer(opts $ dimension),
		height = 1.317 * as.integer(opts $ dimension)
	),
	borders = list(
		xlim = c(-11, -5),
		ylim = c(51.5, 55.5)
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

	stopifnot(length(line @ Lines) == 1)
	line @ Lines[[1]] @ coords

})

op <- par(mar = rep(0, 4))





png(
	opts $ outfile,
	width = constants $ dimensions $ width,
	height = constants $ dimensions $ height,
	res = constants $ graph $ res)

	op <- par(mar = rep(0, 4))

	plot(
		coords[[2]], coords[[1]],

		xlim = constants $ borders $ xlim,
		ylim = constants $ borders $ ylim,

		col  = constants $ colour $ blue,

		cex  = constants $ graph $ cex,
		pch  = constants $ graph $ pch
	)

	invisible(lapply(street_segs, function (seg) {
		lines(seg[,1], seg[,2], col = constants $ colour $ grey, lwd = constants $ graph $ lwd)
	}) )

dev.off()
