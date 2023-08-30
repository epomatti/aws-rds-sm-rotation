# aws-rds-sm-rotation

AWS Secrets Manager stored credential rotation with RDS.

Create the `./infra/.auto.tfvars` file:

```terraform
aws_region = "us-east-2"
```

Create the infrastructure:

```sh
terraform -chdir="infra" init
terraform -chdir="infra" apply -auto-approve
```

Output will show the Secrets Manager key for the configuration.

Create the `app.env` file:

```sh
MODE="CACHE"
SECRET_ID="rds!db-00000000-0000-0000-0000-000000000000"
```

Run the application:

```sh
go run .
```
