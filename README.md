# aws-rds-sm-rotation

AWS SM-stored credential rotation with RDS

Create the `./infra/.auto.tfvars` file:

```terraform
aws_region = "us-east-2"
```

Once the infrastructure is ready, create the `.env` file:

```sh
MODE="CACHE"
SECRET_ID=""
```



```sh
go run .
```
