#!/bin/sh

export $(grep -v '^#' .env | xargs)

echo $APPDATA

docker compose -p stormbian down
docker compose -p stormbian rm stormbian
