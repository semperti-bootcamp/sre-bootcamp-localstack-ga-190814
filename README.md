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
