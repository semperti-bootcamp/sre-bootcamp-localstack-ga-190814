#!/bin/bash

### BootCamp - Sprint 2 - Semperti
### Detalle: Download from localstack s3 bucket to localhost 
### Autor: Gonzalo Acosta <gonzalo.acosta@semperti.com>
### Date: 201908

S3_BUCKET_PATH="s3://BootCampMusic"
IMPORT_DIR="./import"
JSON_FILE="BootCampMusic.json"

# Download from s3 bucket 
echo ">>> Script 2 - Import json from s3 bucket to localhost"

# Check first param $1 s3 bucket 
if [ "$1" == "" ] ; then 
	echo "Import from default S3 Bucket: $S3_BUCKET_PATH"
else
	echo "Import from S3 Bucket: $1"
	S3_BUCKET_PATH=$1
fi

# Check second param $2 json 
if [ "$2" == "" ] ; then
	echo "Import Json default: $IMPORT_DIR/$JSON_FILE" 
else
	echo "Import Json: $IMPORT_DIR/$2"
	JSON_FILE=$2
fi

if test -f "$IMPORT_DIR/$JSON_FILE" ; then
	# Upload json to bucket
	echo ">>> WARNING - File $IMPORT_DIR/$JSON_FILE exist"
	exit 1
else
 	echo "Import json to localhost $IMPORT_DIR/$JSON_FILE"	
	aws s3 cp $S3_BUCKET_PATH/$JSON_FILE $IMPORT_DIR

	# Check upload ok
	if [ $? -eq 0 ] ; then
		echo ">>> OK - Import json file: $IMPORT_DIR/$JSON_FILE from $S3_BUCKET_PATH"
	else
		echo ">>> ERROR - Importing json file $S3_BUCKET_PATH/$JSON_FILE into $IMPORT_DIR"
	fi
fi
