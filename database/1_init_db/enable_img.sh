#!/bin/bash

USERNAME=$1;

PG_DATA_DIR=`psql -d quorum_db -U "$USERNAME" -h localhost -c 'SHOW data_directory;' | egrep -o '/.*'`;
chmod -R u+rw "$PG_DATA_DIR";
IMG_DIR="$PG_DATA_DIR/img";
mkdir -p "$IMG_DIR";

tar -xzvf ../../img.tar.gz -C ../../;
rm ../../img.tar.gz;
cp -r "../../img" "$IMG_DIR";
