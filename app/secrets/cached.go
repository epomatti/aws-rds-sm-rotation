package secrets

import (
	"context"
	"encoding/json"
	"main/utils"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/secretsmanager"
	"github.com/aws/aws-secretsmanager-caching-go/secretcache"
)

var (
	client = getCustomClient()
	// secretCache, _ = secretcache.New(func(c *secretcache.Cache) { c.Client = getCustomClient() })

	// FIXME: https://github.com/aws/aws-secretsmanager-caching-go/pull/40
	secretCache, _ = secretcache.New()
)

func GetCachedSecret() RdsMasterCredentials {

	secretId := utils.GetSecretId()
	result, err := secretCache.GetSecretString(secretId)
	utils.Check(err)

	credentials := RdsMasterCredentials{}
	err = json.Unmarshal([]byte(result), &credentials)
	utils.Check(err)

	return credentials
}

func getCustomClient() *secretsmanager.Client {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	utils.Check(err)

	return secretsmanager.NewFromConfig(cfg)
}
