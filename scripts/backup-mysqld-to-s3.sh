#!/bin/bash

### BootCamp - Sprint 2 - Semperti
### Detalle: Backup MySQl to S2 Bucket
### Autor: Gonzalo Acosta <gonzalo.acosta@semperti.com>
### Date: 201908

# Vars
MYSQL_SERVER=10.252.7.178
MYSQL_USER=root
MYSQL_PASS=semperti
BKP_DIR="./backups"
BKP_S3_BUCKET="s3://backup-mysql"
BKP_DIR="./backups"
BKP_FILE="full-backup-$(date +\%F).sql"

# Check mysql conextion
mysql -u$MYSQL_USER -p$MYSQL_PASS -h $MYSQL_SERVER -B -e "show databases;" 2>&1 > /dev/null
if [ $? -eq 1 ] ; then
	echo "ERROR - Check connetion to mysql server $MYSQL_SERVER"
	exit 1
fi

# Check backup dir
if [ ! -d $BKP_DIR ] ; then
	echo "ERROR - Check backup directory $BKP_DIR"
	exit 1
fi

# Check S3 bucket exits
aws s3 ls $BKP_S3_BUCKET 2>&1 > /dev/null
if [ $? -ne 0 ] ; then
	# bucket s3 doesnt exist
	echo "S3 Bucket does not exist. Would you like create? (Y/N) : "  
	read BUCKET
	if [ "$BUCKET" == "Y" ] ; then
		aws s3 mb $BKP_S3_BUCKET 
		[ $? -eq 0 ] && echo "S3 Bucket $BKP_S3_BUCKET is created"
	else
		echo "Dont create S3 Bucket, exit process"
		exit
	fi
fi

# Dump MyDQL Server to localdata 
echo ">>> Stemp 1 - Dump Full MySQL $MYSQL_SERVER to Local filesystem $BKP_DIR/$BKP_FILE"

mysqldump -u $MYSQL_USER -p$MYSQL_PASS --host $MYSQL_SERVER --single-transaction --quick --lock-tables=false --all-databases > $BKP_DIR/$BKP_FILE

# Upload localdata to S3 Bucket 
if [ $? -eq 0 ] ; then

	# backup full is correct upload dump to s3 bucket
	echo "SUCESS - Full Backup MSQL Server"

	echo "Uploading $BKP_DIR/$BKP_FILE to S3 Bucket $BKP_S3_BUCKET"
	aws s3 mv $BKP_DIR/$BKP_FILE $BKP_S3_BUCKET 
	
	# Check upload is correct 
	if [ $? -eq 0 ] ; then
		echo "SUCESS - Upload $BKP_DIR/$BKP_FILE to S3 Bucket $BKP_S3_BUCKET"
		aws s3 ls $BKP_S3_BUCKET/$BKP_FILE
	else
		echo "ERROR - When move $BKP_DIR/$BKP_FILE to S3 Bucket $BKP_S3_BUCKET"
		exit 1
	fi
	
else
	# if fail backup exit the scriptj
	echo "ERROR - Backups Full MyDQL Server FAIL!!"
	exit 1
fi
