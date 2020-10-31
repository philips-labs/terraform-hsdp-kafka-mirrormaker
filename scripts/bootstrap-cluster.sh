#!/bin/bash

usage() {
    cat <<-EOF
usage: bootstrap-cluster.sh
      -d docker
      -t trust_store_password
      -k key_store_password      
EOF
}

update_properties() {
  local trust_pass="$1"
  local key_pass="$2"
  local properties_file="./mm2.properties"

  echo >> "$properties_file"
  echo "security.protocol = SSL" >> "$properties_file"
  echo "ssl.endpoint.identification.algorithm =" >> "$properties_file"
  echo "ssl.truststore.location = /bitnami/kafka/config/certs/truststore.jks" >> "$properties_file"
  echo "ssl.truststore.password =" "$trust_pass" >> "$properties_file"
  echo "ssl.truststore.type = JKS" >> "$properties_file"
  echo "ssl.keystore.location = /bitnami/kafka/config/certs/mm.keystore.jks" >> "$properties_file"
  echo "ssl.keystore.password =" "$key_pass" >> "$properties_file"

  cat $properties_file
}

kill_kafka() {
  echo Killing mm...
  docker kill mm
  docker rm mm
}

create_volume() {
  docker volume rm kafkacert
  docker volume create kafkacert
}

load_certificates() {
  local image=$1
  echo "starting to load certs and properties"
  docker run -d --rm \
  -v kafkacert:/certs/ \
  --name loadvolume \
  "$image" /bin/sh -c "sleep 30"
  docker cp ./truststore.jks loadvolume:/certs/
  docker cp ./mm.keystore.jks loadvolume:/certs/
  docker cp ./mm2.properties loadvolume:/certs/
  docker exec loadvolume ls -laR /certs
  echo sleeping for 30 sec
  sleep 30
  echo done sleeping
  docker ps -a
}

start_kafka_connect() {
  local image="$1"
  
  docker run -d -v mm:/bitnami/kafka \
    --restart always \
    --name mm \
    -v 'kafkacert:/bitnami/kafka/config/certs/' \
    "$image" /opt/bitnami/kafka/bin/connect-mirror-maker.sh /bitnami/kafka/config/certs/mm2.properties 
}

##### Main
image=
index=
key_pass=
trust_pass=
while [ "$1" != "" ]; do
    case $1 in
        -d | --docker )        shift
                               image=$1
                               ;;
        -k | --key-pass )      shift
                               key_pass=$1
                               ;;
        -t | --trust-pass )    shift
                               trust_pass=$1
                               ;;
        -h | --help )          usage
                               exit
                               ;;
        * )                    usage
                               exit 1
    esac
    shift
done


echo Bootstrapping Mirrormaker worker with "$image"

update_properties "$trust_pass" "$key_pass"
kill_kafka
create_volume
load_certificates "$image"
start_kafka_connect  "$image"
