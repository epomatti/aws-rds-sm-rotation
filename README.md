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
MODE="CACHED"
SECRET_ID="rds!db-00000000-0000-0000-0000-000000000000"
```

You can hit the SM API directly or use a [cached secret][1].

> When you retrieve a secret, you can use the Secrets Manager Go-based caching component to cache it for future use. Retrieving a cached secret is faster than retrieving it from Secrets Manager. Because there is a cost for calling Secrets Manager APIs, using a cache can reduce your costs.

Run the application:

```sh
go run .
```

[1]: https://docs.aws.amazon.com/secretsmanager/latest/userguide/retrieving-secrets_cache-go.html
