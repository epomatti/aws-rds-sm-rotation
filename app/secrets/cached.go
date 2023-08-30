package secrets

import (
	"encoding/json"
	"main/utils"

	"github.com/aws/aws-secretsmanager-caching-go/secretcache"
)

var (
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
