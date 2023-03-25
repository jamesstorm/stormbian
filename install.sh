#!/bin/sh

export $(grep -v '^#' .env | xargs)

echo $APPDATA

#mkdir -p $APPDATA/postgres/data
docker compose -p stormbian down
docker compose -p stormbian rm stormbian
docker build . -t jamesstorm/stormbian 
docker compose -p stormbian up -d
