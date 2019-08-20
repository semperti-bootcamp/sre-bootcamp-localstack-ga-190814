## Amazon LocalStack - Instalación

## General

1. Generar el repo en https://github.com/semperti-bootcamp/sre-bootcamp-localstack-ga-190814
2. Generamos el PR base con este README.md
3. Todos los pasos son explicados en el README.md

## Generar S3 Bucket con Terraform

```
cd terraform/s3
terraform init
terraform apply
```

Checkear el s3 bucket creado

aws s3 ls s3://BootCampMusic

![alt tag](https://raw.githubusercontent.com/semperti-bootcamp/sre-bootcamp-localstack-ga-190814/s2a2-terraform/images/terraform-s3.png "terraform-s3")

## Generar la tabla DynamoDB con Terraform

```
cd terraform/dynamodb
terraform init
terraform apply
```

Listar las tablas
```
aws dynamodb list-tables
``` 

## Problemas encontados.

Con la version v0.12 de terraform tuve este inconveniente.

```
:) Sun Aug 18 05:54:04 gonzaloacosta@Gonzalos-MacBook-Pro [~/Documents/Semperti/BootCamp/sprint2/terraform/dynamodb]  
$ terraform apply

Error: insufficient items for attribute "rules"; must have at least 1


:( Sun Aug 18 05:54:10 gonzaloacosta@Gonzalos-MacBook-Pro [~/Documents/Semperti/BootCamp/sprint2/terraform/dynamodb]  
$ terraform -v
Terraform v0.12.6
+ provider.aws v2.24.0
```

En la web encontré que todas las versiones de la v0.12.x tiene inconvenientes, bajé a la v0.11
y pude desplegar sin inconvenientes.


```
$ /usr/local/Cellar/terraform-0.11/0.11.14/bin/terraform -v
Terraform v0.11.14
+ provider.aws v2.24.0

Your version of Terraform is out of date! The latest version
is 0.12.6. You can update by downloading from www.terraform.io/downloads.html
```


![alt tag](https://raw.githubusercontent.com/semperti-bootcamp/sre-bootcamp-localstack-ga-190814/s2a2-terraform/images/terraform-dynamodb.png "terraform-dynamodb")


## Paso 2. 

### Export json -> s3 bucket
Para para el export json -> s3 y el export del json - dynamodb he creado un script 
en bash que realiza toda la tarea. Toma el archivo .json y lo sube al bucket.

Los valores por default que toma son:

	JsonFileName: BootCampMusic
	S3Bucket: s3://BootCampMusic

```
export-json-s3-bucket.sh [ json_file_name | default ] [ s3_bucket_name ] 
``` 

### Import s3 -> DynamoDB 

Para el import de s3 -> DynamoDB cree un script para poder realizar la tarea. La sintaxis
Es la siguiente. 

Los valores por deafult son:

	JsonFileName: BootCampMusic
	ImportDir: ./import
	S3Bucket: s3://BootCampMusic
	DynamoDBTable: BootCampMusic o la que extraigo del Json

```
import-json-s3-dynamodb.sh [ json_file_name | default ] [ s3_bucket_name ]
```

## Paso 3 Dump MySQL Server -> S3 Bucket

Para realizar esta tarea tomé la base de datos remota del sprint 1 (mysql 5.6) que utilizamos para 
la aplicacion Journals. El backup se realiza de manera remota, esto quierer decir que con credenciales
de root desde la maquina local realiza el backup, lo aloja localmente en el directorio scripts/backups
y luego toma el archivo descargado para subirlo al s3 bucket en localstack. Por defecto se utilizó esta
base pero puede realizarse con cualquiera, cargando las variables de entorno del script o pasando o 
pasando como parametro de la siguiente manera.

```
# Defults vars 
MYSQL_SERVER=10.252.7.178
MYSQL_USER=root
MYSQL_PASS=semperti
BKP_DIR="./backups"
BKP_S3_BUCKET="s3://backup-mysql"
BKP_DIR="./backups"
BKP_FILE="full-backup-$(date +\%F).sql"
```

Ejecucion del script
```
backup-mysqld-to-s3.sh
```

El detalle de la ejecucion en estas capturas.

![alt tag](https://raw.githubusercontent.com/semperti-bootcamp/sre-bootcamp-localstack-ga-190814/s2a2-terraform/images/script-import-export.png "script-import-export")
