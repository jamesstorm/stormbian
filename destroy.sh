#!/bin/sh
if [ "$(id -u)" -ne 0 ]; then echo "Please run as root." >&2; exit 1; fi
export $(grep -v '^#' .env | xargs)

DELETE_PROJECT_DIR=false

echo $APPDATA

while getopts 'n:l:dh' opt; do
  case "$opt" in
    n)
      arg="$OPTARG"
      NAME=${OPTARG}
      ;;
    d)
      arg="$OPTARG"
      DELETE_PROJECT_DIR=true 
      ;;
    l)
      arg="$OPTARG"
      PROJECTLOCATON=${OPTARG}
      ;;
    ?|h)
      echo "Usage: $(basename $0) [-n name] [-d delete project dir] [-l path to project] [-h]"
      exit 1
      ;;
  esac
done
rm /usr/local/bin/${NAME}
if $DELETE_PROJECT_DIR; then
    rm -rf ${PROJECTLOCATON}/${NAME}
fi

docker compose -p ${NAME} down 
docker compose -p ${NAME} rm ${NAME}
