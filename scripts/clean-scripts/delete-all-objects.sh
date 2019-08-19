#!/bin/bash

## Autor: Gonzalo Acosta <gonzalo.acosta@semperti.com> 
## Delete all object into localstack

echo ">>> WARNING - Delete all objects into LocalStack Sandbox"
echo "The objects to delete are S3 Bucket, DynamoDB and clean import/export folder.\n"
read -p "Are you sure delete all objects into localstack? (Y/N): " SURE
if [ "$SURE" == "Y" ] ; then 
	# Delete all s3 buckets
	echo ">> S3 Bucket delete all: "
	for bucket in $(aws s3 ls | cut -d" " -f3) ; do
		echo -n "Deleting s3 bucket $bucket.."
		echo -n "Calling the script delete-s3-bucket-versions.sh $bucket"
		./delete-s3-bucket-versions.sh $bucket
		echo "Disabling version"
		aws s3api put-bucket-versioning --bucket $bucket --versioning-configuration Status=Disabled
		aws s3 rm s3://$bucket --recursive && [ $? -eq 0 ] && echo "\tOK Delete all objects into bucket"  
		aws s3 rb s3://$bucket --force && [ $? -eq 0 ] && echo "OK Delete bucket" 
	done	
	# Delete all Dynamodb tables
	echo ">> DynamoDB table: "
	for table in $(aws dynamodb list-tables | jq '."TableNames"[]' | 's/\"//g') ; do
		echo "\tDeleting DynamoDB Table $table"
		aws s3 dynamodb delete-table --table-name $table && [ $? -eq 0 ] && echo "OK Delete table"
	done
else
	echo ">> Thanks to the confirmation, your boss doesn't fire you ;-) "
	echo ">> Send me a black beer to my desk B-)" 
fi

