#!/bin/sh
if [ "$(id -u)" -ne 0 ]; then echo "Please run as root." >&2; exit 1; fi
export $(grep -v '^#' .env | xargs)

echo $APPDATA

while getopts 'n:l:h' opt; do
  case "$opt" in
    n)
      arg="$OPTARG"
      NAME=${OPTARG}
      ;;
    l)
      arg="$OPTARG"
      PROJECTLOCATON=${OPTARG}
      ;;
    ?|h)
      echo "Usage: $(basename $0) [-n name] [-p port] [-l path to project] [-h]"
      exit 1
      ;;
  esac
done
rm /usr/local/bin/${NAME}
rm -rf ${PROJECTLOCATON}/${NAME}

docker compose -p ${NAME} down 
docker compose -p ${NAME} rm ${NAME}
