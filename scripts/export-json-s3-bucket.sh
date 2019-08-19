#!/bin/bash

### BootCamp - Sprint 2 - Semperti
### Detalle: Upload Json to S3 Bucket 
### Autor: Gonzalo Acosta <gonzalo.acosta@semperti.com>
### Date: 201908

## Example
# ./export-json-s3-bucket.sh [ name_s3_bucket ] [ name_json_file ] 

S3_BUCKET_PATH="s3://BootCampMusic"
EXPORT_DIR="./export"
JSON_FILE="BootCampMusic.json"

# Subir json a s3 bucket
echo ">>> Script 1 - Upload the Json file to S3 Bucket"

# Check first param $1 s3 bucket
if [ "$1" == "" ] ; then 
	echo "Upload to default S3 Bucket: $S3_BUCKET_PATH"
else
	echo "Upload to S3 Bucket: $1"
	S3_BUCKET_PATH=$1
fi

# Check second param $2 Json file 
if [ "$2" == "" ] ; then
	echo "Upload default Json file: $EXPORT_DIR/$JSON_FILE" 
else
	echo "Subimos Json: $EXPORT_DIR/$2"
fi

if test -f "$EXPORT_DIR/$JSON_FILE" ; then
	# Upload json to bucket

	echo "Uploading Json $EXPORT_DIR/$JSON_FILE to S3 Bucket $S3_BUCKET_PATH"
	aws s3 cp $EXPORT_DIR/$JSON_FILE $S3_BUCKET_PATH

	# Check upload ok
	if [ $? -eq 0 ] ; then
		echo ">>> OK - Upload success $EXPORT_DIR/$JSON_FILE a $S3_BUCKET_PATH"
	else
		echo ">>> ERROR - An error in the $EXPORT_DIR/$JSON_FILE or $S3_BUCKET_PATH"
	fi
else
	echo ">>> ERROR - The json file $EXPORT_DIR/$JSON_FILE do not exist"
fi
