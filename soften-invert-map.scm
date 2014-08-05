
(define (cli-soften fpath)

	(let* (
		( image (car (gimp-file-load RUN-NONINTERACTIVE fpath fpath)) )
		( drawable (car (gimp-image-flatten image)) ))

		(soften-invert-map image drawable)
		(gimp-file-save RUN-NONINTERACTIVE image drawable fpath fpath)
		(gimp-image-delete image)
	)
)

(define (soften-invert-map image layer)

	(gimp-invert layer)
	(gimp-brightness-contrast layer 71 42)
	(plug-in-softglow RUN-NONINTERACTIVE image layer 50 0.4 0.8)
	(gimp-displays-flush))

(script-fu-register
	"soften-invert-map"
	"Invert & Soften Map"
	"Inverts & Softens Map"
	"Ryan Grannell"
	"Copyright 2014 Ryan Grannell"
	"August 5, 2014"
	""
	SF-IMAGE    "Input Image"    0
	SF-DRAWABLE "Input Drawable" 0
)
