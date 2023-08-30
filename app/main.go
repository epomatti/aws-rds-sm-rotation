package main

import (
	"context"
	"main/utils"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/secretsmanager"
)

func main() {

	cfg, err := config.LoadDefaultConfig(context.TODO())
	utils.Check(err)

	client := secretsmanager.NewFromConfig(cfg)

	var secretId string = "rds!db-10db40ec-cebd-4ade-9865-a4b99718a0a1"

	input := &secretsmanager.GetSecretValueInput{
		SecretId: &secretId,
	}

	v, err := client.GetSecretValue(context.TODO(), input)
	utils.Check(err)

	println(*v.SecretString)
}
