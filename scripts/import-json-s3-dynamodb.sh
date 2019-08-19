#!/bin/bash

### BootCamp - Sprint 2 - Semperti
### Detalle: Download from localstack s3 bucket to localhost 
### Autor: Gonzalo Acosta <gonzalo.acosta@semperti.com>
### Date: 201908

S3_BUCKET_PATH="s3://BootCampMusic"
IMPORT_DIR="import"
JSON_FILE="BootCampMusic.json"
DYNAMODB_TABLE="BootCampMusic"

### Download Json to localhost

# Download from s3 bucket 
echo ">>> Step 1 - Import json from s3 bucket to localhost"

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

# if json file exist was previusly download 
if test -f "$IMPORT_DIR/$JSON_FILE" ; then
	echo ">>> WARNING - Json file $IMPORT_DIR/$JSON_FILE exist"
else
	# json file don't exist copy from bucket 
 	echo "Download from s3 bucket to localhost: $IMPORT_DIR/$JSON_FILE"	
	aws s3 cp $S3_BUCKET_PATH/$JSON_FILE $IMPORT_DIR
	if [ $? -eq 0 ] ; then
		echo ">>> SUCCESS - Download Json file $IMPORT_DIR/$JSON_FILE from $S3_BUCKET_PATH"
	else
		echo ">>> ERROR - Import Json file $S3_BUCKET_PATH/$JSON_FILE into $IMPORT_DIR"
		echo ">>> IMPORTANT !!! - In this step will not continue with the import DynamoDB Table" 
		exit 1 
	fi
fi

### Step 2 - Populate DynamoDB Talbe with Json file 
echo ">>>"
echo ">>> Step 2 - Populate DynamoDB Table with Json file"

# Read table name from json file and check if this exist 
DYNAMODB_TABLE=$(jq 'keys | .[]' $IMPORT_DIR/$JSON_FILE | sed 's/\"//g')
aws dynamodb list-tables | grep $DYNAMODB_TABLE 2>&1 > /dev/null

if [ $? -eq 1 ] ; then
	# if the table does not exist we do not populate dynamodb
	echo "The table $DYNAMODB_TABLE must be create before to populate"
	exit 1
else
	# if the table exit we populate table with json file
	echo "Importing Json file $JSON_FILE to DynamoDB Table $DYNAMODB_TABLE"
	aws dynamodb batch-write-item --request-items file://$IMPORT_DIR/$JSON_FILE 2>&1 > /dev/null
	if [ $? -eq 0 ] ; then
		echo "Scan table is very expensive process if the json file have a lot entry." 
		read -p "Would you like cointinue with the scan DynamoDB Table $DYNAMODB_TABLE? (Y/N): " SCAN 
		if [ "$SCAN" == "Y" ] ; then 
			echo -n "Record Count: "
			aws dynamodb scan --table-name $DYNAMODB_TABLE | jq '."Count"'
		else
			echo ">>> SUCCESS - Imported Json file $IMPORT_DIR/$JSON_FILE to table $DYNAMODB_TABLE"
		fi 
		
	else
		echo ">>> ERROR - When importing Json file $IMPORT_DIR/$JSON_FILE to table $DYNAMODB_TABLE"
		exit 1
	fi 
fi 

