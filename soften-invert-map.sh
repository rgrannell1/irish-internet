#!/bin/sh

cat soften-invert-map.scm > ~/.gimp-2.8/scripts/soften-invert-map.scm

gimp -i -b '(cli-soften "irish-map.png")' -b '(gimp-quit 0)'
