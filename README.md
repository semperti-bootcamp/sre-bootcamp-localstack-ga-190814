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

aws s3 ls s3://NAMEBUCKET

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


```
Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes 

aws_dynamodb_table.bc_table: Creating...
  arn:                       "" => "<computed>"
  attribute.#:               "" => "2"
  attribute.1123762799.name: "" => "SongTitle"
  attribute.1123762799.type: "" => "S"
  attribute.733857137.name:  "" => "Artist"
  attribute.733857137.type:  "" => "S"
  billing_mode:              "" => "PROVISIONED"
  hash_key:                  "" => "Artist"
  name:                      "" => "MusicBootCamp"
  point_in_time_recovery.#:  "" => "<computed>"
  range_key:                 "" => "SongTitle"
  read_capacity:             "" => "5"
  server_side_encryption.#:  "" => "<computed>"
  stream_arn:                "" => "<computed>"
  stream_label:              "" => "<computed>"
  stream_view_type:          "" => "<computed>"
  tags.%:                    "" => "2"
  tags.Environment:          "" => "bootcamp"
  tags.Name:                 "" => "dynamodb-table-1"
  write_capacity:            "" => "5"
aws_dynamodb_table.bc_table: Creation complete after 1s (ID: MusicBootCamp)

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

dynamodb_table_name = MusicBootCamp
```

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

