package secrets

import (
	"context"
	"encoding/json"
	"main/utils"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/secretsmanager"
)

func GetSecretValue() RdsMasterCredentials {

	cfg, err := config.LoadDefaultConfig(context.TODO())
	utils.Check(err)

	client := secretsmanager.NewFromConfig(cfg)

	secretId := utils.GetSecretId()

	input := &secretsmanager.GetSecretValueInput{
		SecretId: &secretId,
	}

	v, err := client.GetSecretValue(context.TODO(), input)
	utils.Check(err)

	credentials := RdsMasterCredentials{}
	err = json.Unmarshal([]byte(*v.SecretString), &credentials)
	utils.Check(err)

	return credentials
}
