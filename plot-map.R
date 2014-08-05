#!/usr/bin/env Rscript

library(sp)
library(maptools)




colour <- list(
	blue = '#55ACEE',
	grey = '#333f4a'
)

dimensions <- list(
	width  = 1.000 * 2080,
	height = 1.317 * 2080
)




message('-- loading road shapefile (slowest step)')

streets <- readShapeLines('ireland/roads.shp')

message('-- loading tweets')

tweets  <- as.list(read.table('irish-tweets.txt'))




message('-- reshaping street data')

street_segs <- lapply(streets @ lines, function (line) {

	stopifnot(length(line @ Lines) == 1)

	line @ Lines[[1]] @ coords
})





op     <- par(mar = rep(0, 4))

message(paste('-- generating', dimensions $ width, 'x', dimensions $ height, 'map'))

png('irish-map.png', width = dimensions $ width, height = dimensions $ height, res = 300)

	op <- par(mar = rep(0, 4))

	plot(
		tweets[[2]], tweets[[1]],

		xlim = c(-11, -5),
		ylim = c(51.5, 55.5),
		col = colour $ blue, cex = 0.06, pch = 15)

	invisible(lapply(street_segs, function (seg) {
		lines(seg[,1], seg[,2], col = colour $ grey, lwd = 0.02)
	}) )

dev.off()
