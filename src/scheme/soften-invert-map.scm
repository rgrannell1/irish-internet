
(define (soften-invert-map image layer)

	; invert the map colours for a night-time look
	(gimp-invert layer)
	; adjust contrast to soften the appearance of the map.
	(gimp-brightness-contrast layer 71 42)
	; add a low intensity, wide radius glow to make tweets add colour to the city.
	(plug-in-softglow RUN-NONINTERACTIVE image layer 50 0.4 0.8) ;
	(gimp-displays-flush))

(define (cli-soften fpath)

	(let* (
		; bind image to the loaded fpath.
		( image (car (gimp-file-load RUN-NONINTERACTIVE fpath fpath)) )
		; bind drawable to the single layer.
		( drawable (car (gimp-image-flatten image)) ))

		(soften-invert-map image drawable)
		; output the new map.
		(gimp-file-save RUN-NONINTERACTIVE image drawable fpath fpath)
		(gimp-image-delete image)
	)
)

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