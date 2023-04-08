#!/bin/sh
if [ "$(id -u)" -ne 0 ]; then echo "Please run as root." >&2; exit 1; fi
export $(grep -v '^#' .env | xargs)



while getopts 'n:p:l:h' opt; do
  case "$opt" in
    n)
      arg="$OPTARG"
      NAME=${OPTARG}
      ;;
    p)
      arg="$OPTARG"
      PORT=${OPTARG}
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
#shift "$(($OPTIND -1))"

# If port is in use, then bail out.
if lsof -i:$PORT | grep -q 'COMMAND'; then
    echo "Port ${PORT} is in use. See here:"
    lsof -i:$PORT
    exit 1
fi

# If name is in use by Docker, then bail out.
if docker ps -a -f name=$NAME | grep -q "${NAME}"; then
    echo "Name ('${NAME}') is already in use."
    exit 1
fi

# ensure project location path is not already in use.
if [ -d ${PROJECTLOCATON}/${NAME} ]; then
    echo "Location exists - ${PROJECTLOCATON}/${NAME}"
    exit 1
fi




# Do the things.
echo "Doing the things"
mkdir -p ${PROJECTLOCATON}/${NAME}
mkdir -p ${PROJECTLOCATON}/${NAME}/appdata
currentuser=$(who | awk 'NR==1{print $1}')
echo "#!/bin/sh\n\nssh -p ${PORT} james@localhost" >> $PROJECTLOCATON/$NAME/$NAME
chmod +x ${PROJECTLOCATON}/${NAME}/${NAME}
chown -R ${currentuser}:${currentuser} ${PROJECTLOCATON}/${NAME}
ln ${PROJECTLOCATON}/${NAME}/${NAME} /usr/local/bin/${NAME} 
cp ./docker-compose.yml ${PROJECTLOCATON}/${NAME}/
cp ./.env ${PROJECTLOCATON}/${NAME}/
cd ${PROJECTLOCATON}/${NAME}
echo "APPNAME=${NAME}" >> ${PROJECTLOCATON}/${NAME}/.env
echo "PORT=${PORT}" >> ${PROJECTLOCATON}/${NAME}/.env

docker compose -p ${NAME} up -d


