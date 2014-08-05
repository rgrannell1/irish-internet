(define (soften-invert-map image layer)

	(invert layer)
	(gimp-brightness-contrast layer 71 42)
	(plug-in-softglow RUN-NONINTERACTIVE image layer 50 0.4 0.8)
	(gimp-displays-flush)

)
