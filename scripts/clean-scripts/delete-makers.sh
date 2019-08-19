#!/bin/bash
#please provide the bucketname and path to destination folder to restore
# Remove all versions and delete markers for each object
 aws s3api list-object-versions --bucket $1 --prefix $2 --output text | 
 grep "DELETEMARKERS" | while read obj
   do
        KEY=$( echo $obj| awk '{print $3}')
        VERSION_ID=$( echo $obj | awk '{print $5}')
        echo $KEY
        echo $VERSION_ID
        aws s3api delete-object --bucket $1 --key $KEY --version-id $VERSION_ID

   done
aws s3api list-object-versions --bucket $1 --prefix $2
