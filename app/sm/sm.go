package sm

import (
	"context"
	"encoding/json"
	"main/utils"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/secretsmanager"
)

type RdsMasterCredentials struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

func GetSecretValue(secretId string) RdsMasterCredentials {

	cfg, err := config.LoadDefaultConfig(context.TODO())
	utils.Check(err)

	client := secretsmanager.NewFromConfig(cfg)

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
