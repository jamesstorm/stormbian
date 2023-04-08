#!/bin/sh

export $(grep -v '^#' .env | xargs)

echo $APPDATA

docker build . -t jamesstorm/stormbian 
